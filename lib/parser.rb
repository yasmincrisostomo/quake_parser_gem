# frozen_string_literal: true
module QuakeParser
  class Parser
    attr_reader :games

    WORLD_ID = '1022'
    WORLD_NAME = '<world>'

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
        parse_player_info(data)
      when "Kill:"
        parse_kill(data)
      when "ClientDisconnect:"
        disconnect_player(data)
      end
    end

     def start_game
      game_id = @games.size + 1
      @games << Game.new(game_id)
      @id_to_player_name = { WORLD_ID => WORLD_NAME }
    end

    def parse_player_info(data)
      id = data.match(/\d+/).to_s
      post_id = data.match(/\d+/).post_match.to_s
      player_name = post_id.match(/\\.*?\\/).to_s[1..-2]

      if @id_to_player_name[id]
        @games.last.update_player_name(@id_to_player_name[id], player_name)
      else
        @games.last.add_player(player_name)
      end

      @id_to_player_name[id] = player_name
    end

    def parse_kill(data)
      match = data.match(/\d+ \d+ \d+/).to_s
      killer_id, killed_id, death_cause = match.split

      if killer_id == WORLD_ID
        @games.last.decrement_kill(@id_to_player_name[killed_id], death_cause)
      else
        @games.last.increment_kill(@id_to_player_name[killer_id], death_cause)
      end
    end

    def disconnect_player(data)
      player_id = data.match(/\d+/).to_s
      @id_to_player_name[player_id] = nil
    end
  end
end
