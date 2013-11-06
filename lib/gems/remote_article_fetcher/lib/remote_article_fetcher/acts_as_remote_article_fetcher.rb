module RemoteArticleFetcher  
  module ActsAsRemoteArticleFetcher
    mattr_accessor :fetchers_arr
   @@fetchers_arr = nil
    
    extend ActiveSupport::Concern
    
    class ImproperlyConfiguredError < StandardError
      
    end
 
    included do
    end
 
    module ClassMethods
      def acts_as_remote_article_fetcher(options = {})
        extend RemoteArticleFetcher::ActsAsRemoteArticleFetcher::LocalClassMethods
       
       RemoteArticleFetcher::ActsAsRemoteArticleFetcher.fetchers_arr = Array.new
        raise ImproperlyConfiguredError("Fetchers sequence missing") if RemoteArticleFetcher.fetcher_sequence.nil?
        RemoteArticleFetcher.fetcher_sequence.each do |fetcher_str|
         require "remote_article_fetcher/fetchers/#{fetcher_str}.rb"
         fetcherClass = "RemoteArticleFetcher::Fetchers::#{fetcher_str.to_s.classify}".constantize
         raise "Invalid fetcher found: "+fetcher_str if fetcherClass.kind_of? RemoteArticleFetcher::Fetcher
        RemoteArticleFetcher::ActsAsRemoteArticleFetcher.fetchers_arr << fetcherClass
       end
      end
    end
    
    module LocalClassMethods      
      
      def remote_article_fetch(data)
        RemoteArticleFetcher::ActsAsRemoteArticleFetcher.fetchers_arr.each do |fetcherClass|
          result = fetcherClass.fetch(data)
         unless result.nil?
            result[:article_source] = "remote_article_fetcher_#{fetcherClass.to_s.demodulize.underscore}".to_sym
           return result
         end
        end
       
        nil
      end
    end
  end
end
 
ActiveRecord::Base.send :include, RemoteArticleFetcher::ActsAsRemoteArticleFetcher