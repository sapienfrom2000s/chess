require_relative '../lib/abstract_player.rb'
require_relative '../lib/setup.rb'

describe Abstract_Player do 
    
    context 'check if move entered is valid' do
        subject(:board) { Abstract_Player.new }
        it 'returns move if valid' do
            allow(board).to receive(:gets).and_return('h7','L07','K7','Ph4')
            expect(board.input).to eq('Ph4')
        end
    end

    context 'filter out the pieces to be used' do
        it 'returns the hash of right knight' do
            board = Board.new
            setup = Setup.new
            setup.init_knights(board)
            player = Abstract_Player.new
            expect(player.fetch_squares(board,:N, 'b', :white)).to_not be nil
        end
    end

    context 'final filter' do
        it 'returns the length of number of original squares available to piece movement' do 
            board = Board.new
            setup = Setup.new
            setup.init_knights(board)
            player = Abstract_Player.new
            expect(player.number_of_pieces_for_destination(board, player.fetch_squares(board,:N, nil, :white), 'c3')).to eq(1)
        end

        it 'returns the length of number of original squares available to piece movement' do 
            board = Board.new
            setup = Setup.new
            setup.init_knights(board)
            player = Abstract_Player.new
            expect(player.number_of_pieces_for_destination(board, player.fetch_squares(board,:N, nil, :white), 'c4')).to eq(0)
        end

        it 'returns the length of number of original squares available to piece movement' do 
            board = Board.new
            setup = Setup.new
            setup.init_knights(board)
            player = Abstract_Player.new
            expect(player.number_of_pieces_for_destination(board, player.fetch_squares(board,:N, nil, :white), 'f3')).to eq(1)
        end

        it 'returns the length of number of original squares available to piece movement' do 
            board = Board.new
            setup = Setup.new
            setup.init_knights(board)
            player = Abstract_Player.new
            expect(player.number_of_pieces_for_destination(board, player.fetch_squares(board,:N, nil, :white), 'h3')).to eq(1)
        end
    end
end