# coding: utf-8
require 'sinatra/base'
require './app/Sound.rb'
require './app/db.rb'
require './app/Sensor.rb'
require './app/const.rb'

class HiyoriApp < Sinatra::Base

  before do
    @db = DbManager.new
  end

  helpers do
    def sound_arg(wind, rain)
      w = !wind[:value].nil?
      r = !rain[:value].nil?
      if w and r
        'wind'+wind[:value][-5] +"','"+ 'rain'+rain[:value][-5]
      elsif w and !r
        'wind'+wind[:value][-5]
      elsif !w and r
        'rain'+rain[:value][-5]
      else
        nil
      end
    end

    def message(sound_arg)
      if sound_arg.include?('wind') and sound_arg.include?('rain')
        '風、雨'
      elsif sound_arg.include?('wind')
        '風'
      elsif sound_arg.include?('rain')
        '雨'
      else
        '無'
      end
    end
  end

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
    @location = location
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

    location_data = @data.find{|v|v[:name]==@location.gsub('-', '_')}
    #location_data = location_data unless location == "favicon.ico"
    unless location_data.nil?
      wind = location_data[:data].find{|v|v[:name]=='WindSound'}
      rain = location_data[:data].find{|v|v[:name]=='RainSound'}
      @soundarg = sound_arg(wind, rain)
      #@message = message(@soundarg)
    end
    #puts @message
    haml :play
  end

end
