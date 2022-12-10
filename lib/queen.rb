require 'pry-byebug'

require_relative 'abstract_piece'
require_relative 'bishop'
require_relative 'rook'

class Queen < Abstract_Piece

    UNIT_LENGTH = 1

    attr_reader :color, :piece_id, :rendered, :board, :bishop, :rook

    def initialize(color, piece_id, board)
        @color = color
        @piece_id = piece_id
        @rendered = piece(color)
        @board = board
        @bishop = Bishop.new(color, :B, board)
        @rook = Rook.new(color, :R, board)
    end

    def piece(color)
        {white: '♕', black: '♛'}[color]
    end

    def potential_squares(coordinate)
        relative_moves = []
        current_file = coordinate[0]
        current_rank = coordinate[1].to_i
        relative_moves << bishop.diagonals_available(current_file, current_rank)
        relative_moves << rook.available_linear_squares(current_file, current_rank)
        g = relative_moves.flatten(1).map do |relative_move|
            forge_coordinate(relative_move, current_file, current_rank)
        end
    end

    def potential_captures(coordinate)
        current_file = coordinate[0]
        current_rank = coordinate[1].to_i
        captures = []
        captures << bishop.potential_captures(coordinate)
        captures << rook.potential_captures(coordinate)
        captures.flatten(1)
      end

    def capture_possible?(current_coordinate, destination)
        bishop.capture_possible?(current_coordinate, destination) || rook.capture_possible?(current_coordinate, destination) 
    end
end