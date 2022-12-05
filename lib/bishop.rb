require 'pry-byebug'
require_relative 'abstract_piece.rb'

class Bishop < Abstract_Piece

    UNIT_LENGTH = 1

    attr_reader :color, :piece_id, :rendered, :relative_moves, :board

    def initialize(color, piece_id, board)
        @color = color
        @piece_id = piece_id
        @rendered = piece(color)
        @relative_moves = []
        @board = board
    end

    def piece(color)
        {white: '♗', black: '♝'}[color]
    end

    def unit_relative_movement
        {[1,1]=>{file:'h',rank: 8}, [1,-1]=>{file:'h',rank: 1}, [-1,-1]=>{file:'a',rank: 1}, [-1,1]=>{file: 'a',rank: 8}}
    end

    def diagonals_available(current_file, current_rank)
        unit_relative_movement.each do |unit_relative_move, bound|
            diagonal_length = [(current_file.ord - bound[:file].ord).abs, (current_rank - bound[:rank]).abs].min
            UNIT_LENGTH.upto(diagonal_length) do |multiplier|
                @relative_moves << unit_relative_move.map{|i| i*multiplier }
                unless board.square_available?(forge_coordinate(relative_moves.last, current_file, current_rank)) 
                    @relative_moves.pop
                    break
                end
            end
        end
    end

    def forge_coordinate(relative_move, current_file, current_rank)
        [(relative_move[0] + current_file.ord).chr, relative_move[1] + current_rank].join
    end

    def potential_squares(slashed_coordinate)
        current_file = slashed_coordinate[0]
        current_rank = slashed_coordinate[1].to_i
        diagonals_available(current_file, current_rank)
        relative_moves.map do |relative_move|
            forge_coordinate(relative_move, current_file, current_rank)
        end
    end
end