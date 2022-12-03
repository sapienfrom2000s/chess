require 'colorize'
require 'pry-byebug'

class Knight

    def self.piece(color)
        {white: '♘', black: '♞'}[color]
    end

    def self.relative_movement
        [[-1,2],[1,2],[2,1],[2,-1],[1,-2],[-1,-2],[-2,-1],[-2,1]]
    end

    def potential_squares(adder)
        file_adder = adder[0].ord
        rank_adder = adder[1].to_i
        self.class.relative_movement.map do |relative_move|
            [(relative_move[0]+file_adder).chr,relative_move[1]+rank_adder].join
        end
    end

    def movement_possible?(current_coordinate, destination)
        a = potential_squares(current_coordinate.split(''))
        a.any?{|potential_square|  potential_square == destination }
    end
    
end