# coding: utf-8

require 'nokogiri'
require 'open-uri'
require 'rexml/document'
require 'savon'

class Sensor

  attr_accessor :id

  def initialize(id)
    @id = id
    @client = Savon.client(wsdl: 'http://live-e2.hongo.wide.ad.jp/axis/services/DataProvider200703?wsdl')
  end

  def operations
    @client.operations
  end

  def get_all_data_hourly_aggregated(starttime, endtime)
    result = []
    re = get_data_hourly_aggregated(starttime, endtime)
    doc = REXML::Document.new(re.body[:get_data_hourly_aggregated_response][:get_data_hourly_aggregated_return])
    doc.elements.each('sensorGroup/sensor/') do |element|
      hash = {
        datatype: element.attributes['sensorType'],
        data: to_hash(element)
      }
      result << hash
    end
    result
  end

  def get_latest_data
    all = []
    body = get('get_latest_data',{id: @id, tz: 'JST', locale: 'Japanese'}).body
    doc = REXML::Document.new(body[:get_latest_data_response][:get_latest_data_return])
    doc.elements.each('sensorGroup/') do |element|
      element.elements.each do |el|
        begin
          hash =  {
              :place => element.attributes['address'],
              :type => el.attributes['sensorType'],
              :value => el.elements[1].text.to_f,
              :time => el.elements[1].attributes['time']
          }
          all << hash
        rescue; next; end
      end
    end
    all
  end

  def get_profile_all
    all = []
    body = get('get_profile_all',
        {
            tz: 'JST',
            locale: 'Japanese'
        }
    ).body
    doc = REXML::Document.new(body[:get_profile_all_response][:get_profile_all_return])
    doc.elements.each('sensorGroup/sensorGroup') do |element|
      element.elements.each do |el|
        all << el.attributes['id'].split('/')[0..-2].join('/')+'/'
      end
    end
    all.uniq
  end

  private

  def get_data_hourly_aggregated(starttime, endtime)
    get('get_data_hourly_aggregated',
      {
        id: @id,
        start: to_timestamp_format(starttime),
        end: to_timestamp_format(endtime),
        tz: 'JST',
        locale: 'Japanese'
      }
    )
  end

  def get(call_type, message)
    @client.call(call_type.to_sym, message: message)
  end

  def to_timestamp_format(time)
    time.strftime('%Y-%m-%dT%H:%M:%S.0000000+09:00')
  end

  def to_hash(element)
    hashes = []
    element.elements.each do |el|
      next unless el.attributes['aggType'] == 'avg'
      hash = {
        time: el.attributes['time'],
        value: el.text.to_f
      }
      hashes << hash
    end
    hashes
  end

end
=begin
all_data = []

s = Sensor.new("live-e.org/WXT510/kashiwanoha-h/")
#s = Sensor.new("tokara.jp/WXT510/Nakano-shima/")
#puts s.get_latest_data
#p s.get_profile_all

s.get_profile_all.each do |id|
  s = Sensor.new(id)
  all_data << [s.get_latest_data, id]
end
all_data.delete_if{|v|v[0] == []}
#all_data.delete_if{|v|!(v[0][0][:time].start_with?('2014'))}
#puts all_data

def array_value_is?(array, sym, str)
  array.each do |v|
    return true unless v[sym].start_with? str
  end
  false
end

all_data.delete_if{|v|array_value_is?(v[0], :time, '2014-08-26')}
puts all_data

#now = Time.now
#puts s.get_all_data_hourly_aggregated(now-300*3600, now)
=end
