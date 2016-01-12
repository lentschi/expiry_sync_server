module CucumberArticleHelpers
  class ArticleHelper
    include RSpec::Matchers
    
    attr_accessor :existing_article, :received_article
    
    def remember_existing_article(error_msg="What do you mean by 'that article'")
      @existing_article.should_not be_nil, error_msg
      @existing_article
    end
    
    def remember_received_article(error_msg="What do you mean by 'received article'")
      @received_article.should_not be_nil, error_msg
      @received_article
    end
  end
end

World(CucumberArticleHelpers)