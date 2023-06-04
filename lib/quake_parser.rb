require_relative 'main'
require_relative 'parser'
require_relative 'game'

module QuakeParser
  def self.run(file_path)
    main = QuakeParser::Main.new(file_path)
    main.parser_and_print
    { games: main.get_games, ranking: main.get_ranking }
  end
end