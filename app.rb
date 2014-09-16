# coding: utf-8
require 'sinatra/base'
require './app/Sound.rb'
require './app/db.rb'
require './app/SensorSOAP.rb'
require './app/const.rb'

class AmaotoLive < Sinatra::Base

  before do
    @db = DbManager.new
    @so = Sound.new
  end

  helpers do
    def sound_arg(wind, rain)
      w = !wind.nil?
      r = !rain.nil?
      if w and r
        'wind'+wind[-5] +"','"+ 'rain'+rain[-5]
      elsif w and !r
        'wind'+wind[-5]
      elsif !w and r
        'rain'+rain[-5]
      else
        nil
      end
    end

    def message(sound_arg)
      if sound_arg.include?('wind') and sound_arg.include?('rain')
        "風#{sound_arg[4]},雨#{sound_arg[-1]}"
      elsif sound_arg.include?('wind')
        "風#{sound_arg[-1]},雨0"
      elsif sound_arg.include?('rain')
        "風邪0,雨#{sound_arg[-1]}"
      else
        '無'
      end
    end

    def to_place_data(data)
      ret = {}
      data.delete_if{|v|v[:type]=='DayRainFall'}.each do |hash|
        ret[hash[:type].to_sym] = hash[:value]
      end
      ret
    end

    def to_place_data_sound(data, sound_file_paths)
      ret = {}
      data.delete_if{|v|v[:type]=='DayRainFall'}.each do |hash|
        ret[hash[:type].to_sym] = hash[:value]
      end
      ret[:RainSound] = sound_file_paths[1]
      ret[:WindSound] = sound_file_paths[0]
      ret
    end

    def location_to_id(location)
      Const::PLACES.find{|v|v[:path][5..-4] == location}[:id]
    end

  end
=begin
  get '/' do
    data = []
    Const::PLACES.each do |place|
      hash = {
          name: place[:path][5..-4],
          data: @db.read(place[:path])
      }
      data.push hash
    end
    #puts @data
    #@hiroshima = @data.find{|v|v[:name]=='hiroshima_city_university'}
    @nakano = data.find{|v|v[:name]=='nakano_jima'}
    @kashiwanoha = data.find{|v|v[:name]=='kashiwanoha_high_school'}
    @aori = data.find{|v|v[:name]=='otsuchi_u_tokyo'}
    haml :index
  end
=end

  get '/' do
    place_data = []
    Const::PLACES.each do |place|
      next if place[:path].include?('dummy')
      s = Sensor.new(place[:id])
      latest = s.get_latest_data
      hash = {
          name: place[:path][5..-4],
          data: to_place_data(latest)
      }
      place_data << hash
    end
    @nakano = place_data.find{|v|v[:name]=='nakano_jima'}
    @kashiwanoha = place_data.find{|v|v[:name]=='kashiwanoha_high_school'}
    @aori = place_data.find{|v|v[:name]=='otsuchi_u_tokyo'}
    haml :index
  end

  get '/main.css' do
    scss :'/main'
  end

  get '/play.css' do
    scss :'/play'
  end

  #get '/dummy_rain' do
  #  @location = 'dummy-rain'
  #  @soundarg = "wind2','rain3"
  #  haml :play
  #end

  get '/:location' do |location|
=begin

    @data = []
    Const::PLACES.each do |place|
      hash = {
          name: place[:path][5..-4],
          data: @db.read(place[:path])
      }
      @data.push hash
    end

    #p @data.find{|v|v[:name]==@location.gsub('-', '_')}
    #@data.each do |v|
    #  p v[:name]
    #  p @location.gsub('-', '_')
    #end
=end

    @location = location
    s = Sensor.new(location_to_id(@location.gsub('-', '_')))
    latest = s.get_latest_data
    @so.load(latest)
    @location_data = {data: to_place_data_sound(latest, @so.sounds)}

    #@location_data = @data.find{|v|v[:name]==@location.gsub('-', '_')}
    unless @location_data.nil?
      wind = @location_data[:data][:WindSound]
      rain = @location_data[:data][:RainSound]
      @soundarg = sound_arg(wind, rain)
      @soundarg = '' if @soundarg.nil?
      @message = message(@soundarg)
      haml :play
    end
  end
  0
end
