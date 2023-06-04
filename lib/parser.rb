# frozen_string_literal: true

require_relative 'game'

module QuakeParser
  class Parser
    attr_reader :games

    WORLD = '1022'

    def initialize(log)
      @log = log
      @games = []
    end

    def parse_file
      @log.each_line { |line| parse_line(line) }
    end

    def start_game
      @games << QuakeParser::Game.new(@games.size + 1)
      @player_id_to_name_map = { WORLD => '<world>' }
    end

    def parse_line(line)
      match = line.match(/\d+:\d+ \w+:/)
      return unless match

      task = match.string.split(' ')[1]
      data = match.post_match.strip
      parse_task(task, data)
    end

    def parse_task(task, data)
      case task
      when "InitGame:"
        start_game
      when "ClientUserinfoChanged:"
        parse_update(data)
      when "Kill:"
        parse_kill(data)
      when "ClientDisconnect:"
        @player_id_to_name_map[data.match(/\d+/).to_s] = nil
      end
    end

    def parse_update(data)
      id = data.match(/\d+/).to_s
      post_id = data.match(/\d+/).post_match.to_s
      name = post_id.match(/\\.*?\\/).to_s[1..-2]

      if @player_id_to_name_map[id]
        @games.last.update_player_name(@player_id_to_name_map[id], name)
      else
        @games.last.add_player(name)
      end
      @player_id_to_name_map[id] = name
    end

    def parse_kill(data)
      killer, killed, mod = data.match(/\d+ \d+ \d+/).to_s.split(" ")

      if killer == WORLD
        @games.last.decrement_kill(@player_id_to_name_map[killed], mod)
      else
        @games.last.increment_kill(@player_id_to_name_map[killer], mod)
      end
    end
  end
end
