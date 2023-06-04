require_relative '../lib/main'
require 'stringio'

RSpec.describe QuakeParser::Main do
  describe '#initialize' do
    context 'when file does not exist' do
      it 'raises an error' do
        expect { described_class.new('file.log') }.to raise_error(Errno::ENOENT)
      end
    end
  end

  describe '#execute' do
    context 'when file exists' do
      let(:main) { described_class.new('spec/fixtures/game.log') }
      let(:expected_output) { File.read('spec/fixtures/report.txt') }
      let(:output) { StringIO.new }

      before do
        $stdout = output
      end

      after do
        $stdout = STDOUT
      end

      it 'returns the expected output' do
        main.execute
        expect(output.string.strip).to eq(File.read('spec/fixtures/report.txt').strip)
      end
    end
  end
end
