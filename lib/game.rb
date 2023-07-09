# frozen_string_literal: true

require 'json'

module QuakeParser
  class Game
    attr_reader :kills, :kills_by_means, :players

    DEATH_CAUSES = {
      '0' => 'MOD_UNKNOWN', '1' => 'MOD_SHOTGUN', '2' => 'MOD_GAUNTLET', '3' => 'MOD_MACHINEGUN',
      '4' => 'MOD_GRENADE', '5' => 'MOD_GRENADE_SPLASH', '6' => 'MOD_ROCKET', '7' => 'MOD_ROCKET_SPLASH',
      '8' => 'MOD_PLASMA', '9' => 'MOD_PLASMA_SPLASH', '10' => 'MOD_RAILGUN', '11' => 'MOD_LIGHTNING',
      '12' => 'MOD_BFG', '13' => 'MOD_BFG_SPLASH', '14' => 'MOD_WATER', '15' => 'MOD_SLIME',
      '16' => 'MOD_LAVA', '17' => 'MOD_CRUSH', '18' => 'MOD_TELEFRAG', '19' => 'MOD_FALLING',
      '20' => 'MOD_SUICIDE', '21' => 'MOD_TARGET_LASER', '22' => 'MOD_TRIGGER_HURT', '23' => 'MOD_NAIL',
      '24' => 'MOD_CHAINGUN', '25' => 'MOD_PROXIMITY_MINE', '26' => 'MOD_KAMIKAZE', '27' => 'MOD_JUICED',
      '28' => 'MOD_GRAPPLE'
    }

    def initialize(game_id)
      @game_id = game_id
      @total_kills = 0
      @players = []
      @kills = Hash.new(0)
      @kills_by_means = Hash.new(0)
    end

    def add_player(name)
      @players << name unless @players.include?(name)
      @kills[name] = 0
    end

    def update_player_name(old_name, new_name)
      @kills[new_name] = @kills.delete(old_name)
      @players[@players.index(old_name)] = new_name
    end

    def increment_kill(killer, death_cause = '0')
      @total_kills += 1
      @kills[killer] += 1
      @kills_by_means[DEATH_CAUSES[death_cause]] += 1
    end

    def decrement_kill(killed, death_cause = '0')
      @total_kills += 1
      @kills[killed] -= 1
      @kills_by_means[DEATH_CAUSES[death_cause]] += 1
    end

    def convert_data_to_hash
      {
        'game_id' => @game_id,
        'total_kills' => @total_kills,
        'players' => @players,
        'kills' => @kills,
        'kills_by_means' => @kills_by_means
      }
    end

    def convert_data_to_json
      JSON.pretty_generate(convert_data_to_hash)
    end
  end
end