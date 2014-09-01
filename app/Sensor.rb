# encoding: utf-8

require 'nokogiri'
require 'open-uri'
require 'rexml/document'

class SensorREST

  def get_place_latest(place)
    array = get_latest_all.select do |data|
      data[:place].include?(place)
    end
    array.delete_if{|v|v[:place] != array[0][:place]}
  end

  def get_latest_all
    all = []
    doc = REXML::Document.new(open('http://live-e.naist.jp/data/getLatestDataAll/'))
    #puts doc
    doc.elements.each('sensorGroup/sensorGroup') do |element|
      element.elements.each do |el|
        begin
            hash =  {
              :place => element.attributes['address'],
              :type => el.attributes['sensorType'],
              :id => element.attributes['id'],
              :value => el.elements[1].text.to_f,
              :time => el.elements[1].attributes['jptime']
            }
            all << hash
        rescue; next; end
      end
    end
    all
  end

end

#so = SensorREST.new
#puts so.get_latest_all
#p so.get_place_latest('千葉県柏市柏の葉 ６－１')
#p so.get_place_latest('Hiroshima')
