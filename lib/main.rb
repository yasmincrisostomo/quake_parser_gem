require_relative 'parser'

module QuakeParser
  class Main
    def initialize(file_path)
      raise Errno::ENOENT, "File not found or unreadable: #{file_path}" unless File.exist?(file_path)

      @parser = QuakeParser::Parser.new(File.read(file_path))
    end

    def execute
      @parser.parse_file
      print_games
      print_ranking
    end

    def print_games
      @parser.games.each { |game| puts game.convert_data_to_json if game }
    end

    def print_ranking
      scores = Hash.new(0)

      @parser.games.each do |game|
        next unless game

        game.kills.each do |key, value|
          scores[key] += value
        end
      end

      ranking = scores.sort_by { |_key, value| -value }.to_h
      puts "global_ranking: #{JSON.pretty_generate(ranking)}\n"
    end
  end
end