# frozen_string_literal: true

require_relative 'game'

module QuakeParser
  class Parser
    attr_reader :games

    WORLD = '1022'

    def initialize(log_file)
      @log_file = log_file
      @games = []
    end

    def parse_file
      @log_file.each_line { |line| parse_line(line) }
    end

    def parse_line(line)
      match = line.match(/\d+:\d+ \w+:/)
      return unless match

      command = match.string.split[1]
      data = match.post_match.strip
      parse_command(command, data)
    end

    def parse_command(command, data)
      case command
      when "InitGame:"
        start_game
      when "ClientUserinfoChanged:"
        parse_update_player(data)
      when "Kill:"
        parse_kill(data)
      when "ClientDisconnect:"
        @id_to_player_name[data] = nil
      end
    end

     def start_game
      game_id = @games.size + 1
      @games << QuakeParser::Game.new(game_id)
      @id_to_player_name = { 
        WORLD => '<world>' 
      }
    end

    def parse_update_player(data)
      id = data.match(/\d+/).to_s
      post_id = data.match(/\d+/).post_match.to_s
      name = post_id.match(/\\.*?\\/).to_s[1..-2]

      if @id_to_player_name[id]
        @games.last.update_player_name(@id_to_player_name[id], name)
      else
        @games.last.add_player(name)
      end
      @id_to_player_name[id] = name
    end

    def parse_kill(data)
      killer, killed, death_cause = data.match(/\d+ \d+ \d+/).to_s.split

      if killer == WORLD
        @games.last.decrement_kill(@id_to_player_name[killed], death_cause)
      else
        @games.last.increment_kill(@id_to_player_name[killer], death_cause)
      end
    end
  end
end
