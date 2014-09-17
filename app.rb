# coding: utf-8
require 'sinatra/base'
require './app/Sound.rb'
require './app/db.rb'
require './app/sensorSOAP.rb'
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
        ''
      end
    end

    def to_message(sound_arg)
      if sound_arg.include?('wind') and sound_arg.include?('rain')
        "風#{sound_arg[4]},雨#{sound_arg[-1]}"
      elsif sound_arg.include?('wind')
        "風#{sound_arg[-1]},雨0"
      elsif sound_arg.include?('rain')
        "風0,雨#{sound_arg[-1]}"
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

    def get_id_by_location(location)
      Const::PLACES.find{|v|v[:path][5..-4] == location}[:id]
    end

    def sensor?(location)
      !Const::PLACES.find{|v|v[:path][5..-4] == location}.nil?
    end

    def dummy?(location)
      location.include?('dummy')
    end

  end

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

  get '/:location' do |location|
    break unless sensor? location
    @location = location
    if dummy? location
      db_read_return = @db.read(Const::PLACES.find{|v|v[:path][5..-4]==location.gsub('-', '_')})
      @location_data = {data: db_read_return[:path]} unless db_read_return.nil?
    else
      s = Sensor.new(get_id_by_location(location.gsub('-', '_')))
      latest = s.get_latest_data
      @so.load(latest)
      @location_data = {data: to_place_data_sound(latest, @so.sounds)}
    end
    unless @location_data.nil?
      wind = @location_data[:data][:WindSound]
      rain = @location_data[:data][:RainSound]
      @soundarg = sound_arg(wind, rain)
      @message = to_message(@soundarg)
      haml :play
    end
  end

  get '/main.css' do
    scss :'/main'
  end

  get '/play.css' do
    scss :'/play'
  end

end
