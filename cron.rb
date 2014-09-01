# coding: utf-8

require './app/Sound.rb'
require './app/db.rb'
#require './app/Sensor.rb'
require './app/sensorSOAP.rb'
require './app/const.rb'

#instance
d = DbManager.new
so = Sound.new

#cron
Const::PLACES.each do |place|
  next if place[:path].include?('dummy')
  s = Sensor.new(place[:id])
  latest = s.get_latest_data
  so.load(latest)
  d.insert(place[:path], latest, so.sounds)
end

#reading data
#p d.read('./db/hokkaido.db')
