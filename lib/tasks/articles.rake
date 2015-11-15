namespace :articles do
  desc "Fetch article's data from the remotes. Additional params will restrict the engines used (fetch_remote[barcode,engine1,engine2,...)"
  task :fetch_remote, [:barcode] => [:environment] do |task, args|
    unless args.extras.empty?
      RemoteArticleFetcher.fetcher_sequence.select! do |fetcher_str|
        args.extras.include?(fetcher_str.to_s)
      end
    end
    
    ret_arr = Article.remote_article_fetch({barcode: args[:barcode]}, :all)
    puts ret_arr.to_yaml
  end
  
  desc "List all barcodes found on the remotes. Additional params will restrict the engines used (fetch_remote[limit,engine1,engine2,...)"
  task :list_remote_barcodes, [:limit] => [:environment] do |task, args|
    unless args.extras.empty?
      RemoteArticleFetcher.fetcher_sequence.select! do |fetcher_str|
        args.extras.include?(fetcher_str.to_s)
      end
    end
    
    ret_arr = Article.remote_fetch_available_barcodes(args[:limit].nil? ? nil : args[:limit].to_i)
    puts ret_arr.to_yaml
  end

  desc "Compare remote article fetcher results. Additional params will restrict the engines used (fetch_remote[limit,engine1,engine2,...)"  
  task :compare_fetchers, [:limit] => [:environment] do |task, args|
    unless args.extras.empty?
      Article # required to initialize fetchers_arr
      original_fetchers_arr = RemoteArticleFetcher::ActsAsRemoteArticleFetcher.fetchers_arr.dup
      RemoteArticleFetcher::ActsAsRemoteArticleFetcher.fetchers_arr.select! do |fetcherClass|
        args.extras.include?(fetcherClass.to_s.demodulize.underscore)
      end
    end
    
    ret_arr = Article.remote_fetch_available_barcodes(args[:limit].nil? ? nil : args[:limit].to_i)
    RemoteArticleFetcher::ActsAsRemoteArticleFetcher.fetchers_arr = original_fetchers_arr unless original_fetchers_arr.nil?
      
    ret_arr.each do |barcodesList|
      articleSource = barcodesList[:article_source]
        
      puts "Comparing #{barcodesList[:barcodes].length} barcodes from #{barcodesList[:article_source].to_s}'s list:"
      stats_hash = Hash.new
      barcodesList[:barcodes].each do |barcode|
        result_arr = Article.remote_article_fetch({barcode: barcode}, :all)
        name = nil
        result_arr.each do |result|
          if result[:article_source] == articleSource
            name = result[:name]
            break
          end
        end
        
        next if name.nil?
        
        result_arr.each do |result|
          curArticleSource = result[:article_source]
          next if curArticleSource == articleSource
            
          stats_hash[curArticleSource] = {exists: 0, names_match: 0, names_similar: 0} unless stats_hash.has_key?(curArticleSource)
          stats_hash[curArticleSource][:exists] += 1
          puts "#{curArticleSource}: '#{result[:barcode]}': '#{name.mb_chars}' <==> '#{result[:name].mb_chars}'"
          stats_hash[curArticleSource][:names_match] += 1 if result[:name].mb_chars == name.mb_chars
          
          arr1 = name.encode('UTF-8', :invalid => :replace).split(/\s/).map {|word| word.downcase}
          arr2 = result[:name].encode('UTF-8', :invalid => :replace).split(/\s/).map {|word| word.downcase}
          arr1.each do |word|
            if word.length > 3 and arr2.include?(word)
              stats_hash[curArticleSource][:names_similar] += 1
              break
            end
          end
        end
        sleep 0.2
      end
      puts "Results: " + stats_hash.to_yaml.to_s
    end
  end
end
