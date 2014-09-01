# encoding: utf-8
require 'sequel'


class DbManager

  def insert(dbname, data, sound_file_paths)
    db = Sequel.connect("sqlite://#{dbname}")
    data.delete_if{|v|v[:type]=='DayRainFall'}.each do |hash|
      db[hash[:type].to_sym].insert(time: hash[:time], value: hash[:value])
    end
    db[:rainsound].insert(time: data[0][:time], filepath: sound_file_paths[1])
    db[:windsound].insert(time: data[0][:time], filepath: sound_file_paths[0])
  end

  def read(dbname)
    result = []
    db = Sequel.connect("sqlite://#{dbname}")
    sqlite_master(db).uniq.each do |table|
      begin
        if table.to_sym == :RainSound or table.to_sym == :WindSound
          data = {
              name: table,
              value: db[table.to_sym].all[-1][:filepath]
          }
        else
          data = {
            name: table,
            value: db[table.to_sym].all[-1][:value]
          }
        end
        result << data
      rescue; next; end
    end
    result
  end

  private

  def sqlite_master(db)
    tables = []
    db[:sqlite_master].all.uniq.each do |table|
      tables << table[:tbl_name]
    end
    tables
  end

end

#s = SensorREST.new
#d = DbManager.new()
#d.insert('../db/hiroshima_city_university.db', s.get_place_latest('hiroshima'))
#p d.read('../db/data.db')
