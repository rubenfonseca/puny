# -*- coding: utf-8 -*-
# vim:tabstop=4:expandtab:sw=4:softtabstop=4

require 'rexml/document'
require 'open-uri'
require 'cgi'

# == PunyURL
# 
# Object that holds the different URLs available on a Puny response
# 
class PunyURL
  attr_accessor :puny, :ascii, :preview, :url
end

# == Puny
#
# Holds the methods available on the Puny API
#
# (see http://services.sapo.pt/Metadata/Service/PunyURL?culture=EN)
#
class Puny
  TO_PUNY   = 'http://services.sapo.pt/PunyURL/GetCompressedURLByURL'
  FROM_PUNY = 'http://services.sapo.pt/PunyURL/GetURLByCompressedURL'
  
  # Shortens a URL
  #
  # Returns a PunyURL instance with the shortened version of the URL,
  # or <tt>nil</tt> if there was an error
  #
  # Example:
  #   
  #   require 'puny'
  #   puny = Puny.shorten('http://developers.sapo.pt')
  #   puts puny.puny
  #   puts puny.url
  #
  def self.shorten(url)
    url = TO_PUNY << '?url=' << CGI.escape(url)
    _process_response(open(url))
  end
  
  # Expands a puny URL to the original URL
  #
  # Returns a String instance with the original URL or <tt>nil</tt>
  # if there was an error
  #
  # Example:
  #   
  #   require 'puny'
  #   puts Puny.expand('http://b.ot.sl.pt')
  #
  def self.expand(url)
    url = FROM_PUNY << '?url=' << CGI.escape(url)
    p = _process_response(open(url))
    p.url
  end
  
  private

  # Private method to parse SAPO's WS responses
  def self._process_response(body)
    doc = REXML::Document.new(body).root
    
    begin
      puny_url = PunyURL.new
      puny_url.url     = doc.elements['url'].text
      puny_url.ascii   = doc.elements['ascii'].text
      puny_url.preview = doc.elements['preview'].text
      puny_url.puny    = doc.elements['puny'].text
    
      return puny_url
    rescue
      nil
    end
  end
end
