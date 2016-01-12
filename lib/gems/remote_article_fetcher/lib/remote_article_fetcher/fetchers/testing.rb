require 'remote_article_fetcher/fetcher'

module RemoteArticleFetcher  
  module Fetchers
    # Remote article fetcher for testing only!
    # (On evironments other than testing this should *NOT* be
    # included in +config.fetcher_sequence+)
    class Testing < RemoteArticleFetcher::Fetcher
      AVAILABLE_ARTICLES = [
        {
          barcode: '0704679371330',
          name: 'Supergood crisp yoghurt',
          image: 'yoghurt',
          producer: 'TrueYoghurt'
        },
        {
          barcode: '4017170008725',
          name: 'Superfat Butter',
          image: 'butter',
          producer: 'Butter Lord'
        },
        {
          barcode: '7610848570554',
          name: 'Hard as Iron Muesli',
          image: 'muesli',
          producer: 'Muesli Inc.'
        },
        {
          barcode: '0704679311334',
          name: 'Thai Curry Paste',
          image: 'curry',
          producer: 'CurryCurryIndia Ltd.'
        },
        {
          barcode: '0704679311335',
          name: 'Fruit Salad',
          image: 'salad',
          producer: "Fruits'r'us"
        },
      ]
            
      def self.fetch(data)
        data = data.deep_dup
        
        article = AVAILABLE_ARTICLES.find { |article| article[:barcode] == data[:barcode] }
        return nil if article.nil?
        
        data.merge!({
          name: article[:name],
          producer_attributes: {name: article[:producer]},
          images_attributes: [{
            source_url: article[:image] + ".jpg",
            original_basename: article[:image],
            original_extname: '.jpg',
            mime_type: 'image/jpeg',
            image_data: File.read(File.dirname(__FILE__) + "/testing_images/" + article[:image] + ".jpg")
          }]
        })
          
        data
      end
    end
  end
end