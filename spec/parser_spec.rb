require_relative '../lib/main'

RSpec.describe QuakeParser::Parser do
  let(:parser) { described_class.new(File.open('spec/fixtures/games.log')) }

  describe '#initialize' do
    it 'creates a new parser' do
      expect(parser).to be_a(described_class)
    end
  end

  describe '#parse_file' do
    before do
      parser.parse_file
    end

    it 'parses the file' do
      expect(parser.games.count).to eq(21)
    end
  end

  describe '#parse_line' do
    let(:parser) { described_class.new(nil) }

    it 'ignores lines without a task' do
      line = 'This is not a valid log line'
      expect(parser).not_to receive(:parse_task)

      parser.parse_line(line)
    end

    it 'parses valid lines and calls parse_task' do
      line = '0:00 ClientUserinfoChanged: 2 n\Isgalamido\t\0\tred\t0\t0'
      expect(parser).to receive(:parse_task).with('ClientUserinfoChanged:', '2 n\Isgalamido\t\0\tred\t0\t0')

      parser.parse_line(line)
    end
  end

  describe '#parse_task' do
    before do
      allow_any_instance_of(described_class).to receive(:start_game)
      allow_any_instance_of(described_class).to receive(:parse_update)
      allow_any_instance_of(described_class).to receive(:parse_kill)
    end

    it 'calls the correct method based on the task' do
      parser.parse_task('InitGame:', '')
      parser.parse_task('ClientUserinfoChanged:', '2 n\Isgalamido\t\0\tred\t0\t0')
      parser.parse_task('Kill:', '1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT')

      expect(parser).to have_received(:start_game).once
      expect(parser).to have_received(:parse_update).once.with('2 n\Isgalamido\t\0\tred\t0\t0')
      expect(parser).to have_received(:parse_kill).once.with('1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT')
    end
  end
end
