module RemoteArticleFetcher
  # Abstract base class for remote article fetchers
  class Fetcher
    
    # Fetches article data from the remote server(s)
    #
    # The supplied data can contain any of the available
    # +Article+ fields, depending on wethere there are 
    # essential fields present/missing, the fetcher
    # must decide, if any data can be retrieved.
    # 
    # For example you might have a fetcher, that fetches articles
    # via barcode only and another that also supports fetching by name.
    #
    # At least :barcode should be supported by derived classes!  
    # 
    # ==== Attributes
    # - *data* +Hash+ of article data (keys same as field names as in +Article+)
    # 
    # ==== Returns
    # a +Hash+ of article data as returned by the remote server(s)
    # or +nil+, if nothing was found
    #
    def self.fetch(data)
      nil
    end
    
    # Fetches a list of barcodes from the remote server(s)
    #
    # ==== Attributes
    # - *limit* maximum number of barcodes to fetch (if nil, no limit is set)
    # 
    # === Returns
    # - +Array+ of barcodes (as +String+)
    def self.fetch_barcodes(limit = nil)
      []
    end
  end
end