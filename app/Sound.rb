# coding: utf-8

class Sound

  def initialize
    @rain_fall, @wind_speed, @sounds = nil, nil, []
    %w(wind rain).each do |kind|
      load_files("./public/sounds/#{kind}").each do |file|
        @sounds.push set_file_stat("./public/sounds/#{kind}/#{file}", kind, file[-5])
      end
    end
  end

  def load(data)
    @rain_fall = data.find{|v|v[:type]=='RainFall'}[:value].to_i
    @wind_speed = data.find{|v|v[:type]=='WindSpeed'}[:value].to_i
  end

  def sounds
    begin
      w = wind_judge_path[:path]
      #[wind_judge_path[:path], rain_judge_path[:path]]
    rescue
      w = nil
    end
    begin
      r = rain_judge_path[:path]
    rescue
      r = nil
    end
    [w, r]
    #(paths[0].nil? or paths[1].nil?) ? %w(0 0) : [paths[0][:path], paths[1][:path]]

    #p paths
  end

  private

  def wind_judge_path
    return nil if @wind_speed.nil?
    @sounds.find{|v|v[:level] == wind_level and v[:kind] == 'wind'}
  end

  def rain_judge_path
    return nil if @rain_fall.nil?
    @sounds.find{|v|v[:level] == rain_level and v[:kind] == 'rain'}
  end

  def wind_level
    case @wind_speed
      when 0 then 0
      when 1..7 then 1
      when 8..10 then 2
      else 3
    end
  end

  def rain_level
    case @rain_fall
      when 0 then 0
      when 1..15 then 1
      when 16..25 then 2
      when 26..35 then 3
      when 36..40 then 4
      else 5
    end
  end

  def load_files(path)
    Dir.entries(path).delete_if{|v| v == '.' or v == '..' or v == '.DS_Store' or !v.include?('.')}
  end

  def set_file_stat(path, kind, level)
    {
        path: path,
        kind: kind,
        level: level.to_i
    }
  end

end

#puts sj.sounds
#p sj.rain_fall
