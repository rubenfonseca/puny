# -*- coding: utf-8 -*-
# vim:tabstop=4:expandtab:sw=4:softtabstop=4

require 'test_helper'

class PunyTest < Test::Unit::TestCase
  def test_to_puny_response_handling
    puny = Puny._process_response('<?xml version="1.0" encoding="utf-8"?>
    <punyURL xmlns="http://services.sapo.pt/Metadata/PunyURL">
        <puny>http://漭.sl.pt</puny>
        <ascii>http://b.ot.sl.pt</ascii>
        <preview>http://b.ot.sl.pt/-</preview>
        <url><![CDATA[http://developers.sapo.pt/]]></url>
    </punyURL>')
    
    assert_equal puny.puny, 'http://漭.sl.pt'
    assert_equal puny.ascii, 'http://b.ot.sl.pt'
    assert_equal puny.preview, 'http://b.ot.sl.pt/-'
    assert_equal puny.url, 'http://developers.sapo.pt/'
  end
  
  def test_from_puny_response_handling
    puny = Puny._process_response('<?xml version="1.0" encoding="utf-8"?>
    <punyURL xmlns="http://services.sapo.pt/Metadata/PunyURL">
        <puny>http://漭.sl.pt</puny>
        <ascii>http://b.ot.sl.pt</ascii>
        <preview>http://b.ot.sl.pt/-</preview>
        <url><![CDATA[http://developers.sapo.pt/]]></url>
    </punyURL>')
    
    assert_equal puny.url, 'http://developers.sapo.pt/'
  end
  
  def test_remote_puny_shorten
    puny = Puny.shorten('http://developers.sapo.pt/')
    
    assert_equal puny.puny, 'http://漭.sl.pt'
    assert_equal puny.ascii, 'http://b.ot.sl.pt'
    assert_equal puny.preview, 'http://b.ot.sl.pt/-'
    assert_equal puny.url, 'http://developers.sapo.pt/'
  end
  
  def test_remote_puny_expand
    assert_equal Puny.expand('http://漭.sl.pt'), 'http://developers.sapo.pt/'
    assert_equal Puny.expand('http://b.ot.sl.pt'), 'http://developers.sapo.pt/'
  end
  
  def test_smoke
    assert_equal 100.times { Puny.shorten('http://developers.sapo.pt') }, 100
  end
end
