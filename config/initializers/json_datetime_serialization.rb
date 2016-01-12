class ActiveSupport::TimeWithZone
    def as_json(options = {})
      # without overriding this, the dateformated in replies to ajax request would look like this:
      # 2015-10-30T14:52:13.532Z
      # instead reply in the same way the HTTP-Date header is formatted:
      # s. http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1
      # -> Fri, 30 Oct 2015 15:57:29 GMT
      strftime('%a, %d %b %Y %H:%M:%S %z') 
    end
end