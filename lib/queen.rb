require 'pry-byebug'

require_relative 'abstract_piece'
require_relative 'bishop'
require_relative 'rook'

class Queen < Abstract_Piece

    UNIT_LENGTH = 1

    attr_reader :color, :piece_id, :rendered, :relative_moves, :board, :bishop, :rook

    def initialize(color, piece_id, board)
        @color = color
        @piece_id = piece_id
        @rendered = piece(color)
        @relative_moves = []
        @board = board
        @bishop = Bishop.new(nil, nil, board)
        @rook = Rook.new(nil, nil, board)
    end

    def piece(color)
        {white: '♕', black: '♛'}[color]
    end

    def potential_squares(slashed_coordinate)
        current_file = slashed_coordinate[0]
        current_rank = slashed_coordinate[1].to_i
        bishop.diagonals_available(current_file, current_rank)
        @relative_moves << bishop.relative_moves
        rook.available_linear_squares(current_file, current_rank)
        @relative_moves << rook.relative_moves
        relative_moves.flatten(1).map do |relative_move|
            forge_coordinate(relative_move, current_file, current_rank)
        end
    end
end