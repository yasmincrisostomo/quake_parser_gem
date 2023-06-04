require_relative '../lib/main'

RSpec.describe QuakeParser::Game do
  let(:game) { described_class.new(1) }

  describe '#initialize' do
    it 'creates a new game' do
      expect(game).to be_a(described_class)
    end
  end

  describe '#add_player' do
    before do
      game.add_player('Player 1')
    end

    it 'adds a new player to the game' do
      expect(game.players).to eq(['Player 1'])
    end
  end

  describe '#update_player_name' do
    before do
      game.add_player('Player 1')
      game.update_player_name('Player 1', 'Player 2')
    end

    it 'updates the player name' do
      expect(game.players).to eq(['Player 2'])
    end
  end

  describe '#increment_kill' do
    before do
      game.add_player('Player 1')
      game.increment_kill('Player 1')
    end

    it 'increments the kill' do
      expect(game.kills).to eq({ 'Player 1' => 1 })
    end
  end

  describe '#decrement_kill' do
    before do
      game.add_player('Player 1')
      game.increment_kill('Player 1')
      game.decrement_kill('Player 1')
    end

    it 'decrements the kill' do
      expect(game.kills).to eq({ 'Player 1' => 0 })
    end
  end

  describe '#convert_data_to_json' do
    before do
      game.add_player('Player 1')
      game.increment_kill('Player 1')
    end

    it 'converts the data to JSON' do
      expected_json = <<~JSON.strip
        {
          "game": 1,
          "total_kills": 1,
          "players": [
            "Player 1"
          ],
          "kills": {
            "Player 1": 1
          },
          "kills_by_means": {
            "MOD_UNKNOWN": 1
          }
        }
      JSON

      expect(JSON.parse(game.convert_data_to_json)).to eq(JSON.parse(expected_json))
    end
  end
end

