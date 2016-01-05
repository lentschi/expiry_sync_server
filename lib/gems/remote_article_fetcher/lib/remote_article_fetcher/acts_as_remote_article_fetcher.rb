module RemoteArticleFetcher
  module ActsAsRemoteArticleFetcher
    mattr_accessor :fetchers_arr
    @@fetchers_arr = nil

    extend ActiveSupport::Concern
    class ImproperlyConfiguredError < StandardError

    end

    included do
    end
    
    def self.load_config
      RemoteArticleFetcher::ActsAsRemoteArticleFetcher.fetchers_arr = Array.new
      raise ImproperlyConfiguredError("Fetchers sequence missing") if RemoteArticleFetcher.fetcher_sequence.nil?
      RemoteArticleFetcher.fetcher_sequence.each do |fetcher_str|
        require "remote_article_fetcher/fetchers/#{fetcher_str}.rb"
        fetcherClass = "RemoteArticleFetcher::Fetchers::#{fetcher_str.to_s.classify}".constantize
        raise "Invalid fetcher found: "+fetcher_str if fetcherClass.kind_of? RemoteArticleFetcher::Fetcher
        RemoteArticleFetcher::ActsAsRemoteArticleFetcher.fetchers_arr << fetcherClass
      end
    end

    module ClassMethods
      def acts_as_remote_article_fetcher(options = {})
        extend RemoteArticleFetcher::ActsAsRemoteArticleFetcher::LocalClassMethods
      end
    end

    module LocalClassMethods
      def remote_article_fetch(data, mode = :first)
        ret_arr = Array.new if mode == :all
        RemoteArticleFetcher::ActsAsRemoteArticleFetcher.fetchers_arr.each do |fetcherClass|
          fetcherName = "remote_article_fetcher_#{fetcherClass.to_s.demodulize.underscore}".to_sym
          result = fetcherClass.fetch(data)
          unless result.nil?
            result[:article_source] = fetcherName
            result[:images_attributes].each do |attrib|
              attrib[:article_source] = fetcherName
            end
            return result if mode == :first
            ret_arr << result
          end
        end

        return nil if mode == :first
        ret_arr
      end
      
      def remote_fetch_available_barcodes(limit = nil)
        ret_arr = Array.new
        RemoteArticleFetcher::ActsAsRemoteArticleFetcher.fetchers_arr.each do |fetcherClass|
          fetcherName = "remote_article_fetcher_#{fetcherClass.to_s.demodulize.underscore}".to_sym
          barcodes_arr = fetcherClass.fetch_barcodes(limit)
          result = {article_source: fetcherName, barcodes: barcodes_arr}
          ret_arr << result
        end
        
        ret_arr
      end
    end
  end
end

ActiveRecord::Base.send :include, RemoteArticleFetcher::ActsAsRemoteArticleFetcher