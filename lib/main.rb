require_relative 'parser'

module QuakeParser
  class Main
    def initialize(file_path)
      raise Errno::ENOENT, "File not found or unreadable: #{file_path}" unless File.exist?(file_path)

      @parser = QuakeParser::Parser.new(File.read(file_path))
    end

    def parser_and_print
      @parser.parse_file
    end
 
    def get_games
      games_data = []
      @parser.games.each { |game| games_data << game.convert_data_to_hash if game }
      games_data
    end
 
    def get_ranking
      scores = Hash.new(0)
 
      @parser.games.each do |game|
        next unless game
 
        game.kills.each do |key, value|
          scores[key] += value
        end
      end
 
      ranking = scores.sort_by { |_key, value| -value }.to_h
      ranking
    end
  end
end