require 'pry-byebug'

class Rook

    UNIT_LENGTH = 1

    attr_reader :color, :piece_id, :rendered, :relative_moves

    def initialize(color, piece_id)
        @color = color
        @piece_id = piece_id
        @rendered = piece(color)
        @relative_moves = []
    end

    def piece(color)
        {white: '♖', black: '♜'}[color]
    end

    def unit_relative_movement
        {[0,1]=> 8, [1,0]=>'h'.ord, [0,-1]=>1, [-1,0]=>'a'.ord}
    end

    def available_linear_squares(current_file, current_rank)
       subtractor = [current_file.ord,current_rank,current_file.ord,current_rank]
        unit_relative_movement.each do |unit_relative_move, bound|
            linear_length = (bound-subtractor.last).abs
            subtractor.pop
            UNIT_LENGTH.upto(linear_length) do |multiplier|
                @relative_moves << unit_relative_move.map{|i| i*multiplier }
            end
        end
    end

    def potential_squares(slashed_coordinate)
        current_file = slashed_coordinate[0]
        current_rank = slashed_coordinate[1].to_i
        available_linear_squares(current_file, current_rank)
        relative_moves.map do |relative_move|
            [(relative_move[0]+current_file.ord).chr,relative_move[1]+current_rank].join
        end
    end

    def movement_possible?(current_coordinate, destination)
        a = potential_squares(current_coordinate.split(''))
        a.any?{|potential_square|  potential_square == destination }
    end

end