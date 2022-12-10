require 'pry-byebug'
require_relative 'abstract_piece.rb'

class Bishop < Abstract_Piece

    UNIT_LENGTH = 1

    attr_reader :color, :piece_id, :rendered, :relative_moves, :board

    def initialize(color, piece_id, board)
        @color = color
        @piece_id = piece_id
        @rendered = piece(color)
        @board = board
    end

    def piece(color)
        {white: '♗', black: '♝'}[color]
    end

    def unit_relative_movement
        {[1,1]=>{file:'h',rank: 8}, [1,-1]=>{file:'h',rank: 1}, [-1,-1]=>{file:'a',rank: 1}, [-1,1]=>{file: 'a',rank: 8}}
    end

    def diagonals_available(current_file, current_rank)
        relative_moves = []
        unit_relative_movement.each do |unit_relative_move, bound|
            diagonal_length = [(current_file.ord - bound[:file].ord).abs, (current_rank - bound[:rank]).abs].min
            UNIT_LENGTH.upto(diagonal_length) do |multiplier|
                relative_moves << unit_relative_move.map{|i| i*multiplier }
                unless board.square_available?(forge_coordinate(relative_moves.last, current_file, current_rank)) 
                    yield(relative_moves.last) if block_given?
                    relative_moves.pop
                    break
                end
            end
        end
        relative_moves
    end

    def potential_squares(coordinate)
        current_file = coordinate[0]
        current_rank = coordinate[1].to_i
        diagonals_available(current_file, current_rank).map do |relative_move|
           forge_coordinate(relative_move, current_file, current_rank)
        end
    end

    def potential_captures(coordinate)
        current_file = coordinate[0]
        current_rank = coordinate[1].to_i
        captures = []
        diagonals_available(current_file, current_rank) do |relative_move|
           occupied_coordinate = forge_coordinate(relative_move, current_file, current_rank)
           captures << occupied_coordinate if board.grid[occupied_coordinate][:piece].color != color &&\
            board.grid[occupied_coordinate][:piece].piece_id != :K
        end
        captures
    end

    def capture_possible?(current_coordinate, destination)
        current_file = current_coordinate[0]
        current_rank = current_coordinate[1].to_i
        destination_file = destination[0]
        destination_rank = destination[1].to_i
        potential_squares = potential_squares(current_coordinate)
        b = unit_relative_movement.keys.filter do |relative_move|
            ((destination_file.ord - current_file.ord)*relative_move[0]).positive? &&\
            ((destination_rank - current_rank) * relative_move[1]).positive?
        end.map{|relative_move| relative_move.map{|fileorrank| fileorrank * (-1)  } }.map\
        do |relative_move|
        forge_coordinate(relative_move, destination_file, destination_rank)
        end
        c = b.any?\
        {|coordinate|  (potential_squares.include?(coordinate) && (board.grid[coordinate][:piece].nil?) || coordinate == current_coordinate)}
    end


end