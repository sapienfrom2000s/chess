require_relative '../lib/setup.rb'

describe Setup do
    
    context 'when knights are initialized' do

    it 'modifies board at b1' do
        board = Board.new
        setup = Setup.new
        setup.init_knights(board)
        expect(board.grid['b1'][:piece_id]).to eq(:N)
        expect(board.grid['b1'][:piece_color]).to eq(:white)
        expect(board.grid['b1'][:square][11]).to eq('♘')
        expect(board.grid['b1'][:square][11]).to_not be nil
    end

    it 'modifies board at b1' do
        board = Board.new
        setup = Setup.new
        setup.init_knights(board)
        expect(board.grid['b8'][:piece_id]).to eq(:N)
        expect(board.grid['b8'][:piece_color]).to eq(:black)
        expect(board.grid['b8'][:square][11]).to eq('♞')
        expect(board.grid['b8'][:square][11]).to_not be nil
    end

  end
end