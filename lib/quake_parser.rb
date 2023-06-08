require_relative 'parser'
require_relative 'game'

module QuakeParser
  def self.run(file_path)
    raise Errno::ENOENT, "File not found or unreadable: #{file_path}" unless File.exist?(file_path)

    @parser = QuakeParser::Parser.new(File.read(file_path))
    @parser.parse_file
    { games: get_games, ranking: get_ranking }
  end

  def self.get_games
    games_data = []
    @parser.games.each { |game| games_data << game.convert_data_to_hash if game }
    games_data
  end

  def self.get_ranking
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