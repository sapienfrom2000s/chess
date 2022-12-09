require 'pry-byebug'

class Abstract_Piece
    def movement_possible?(current_coordinate, destination)
        potential_squares = potential_squares(current_coordinate)
        potential_squares.any?{|potential_square|  (potential_square == destination) }
    end

    def splitter(coordinate)
        split = coordinate.split('')
        [split[0],split[1]]
    end

    def forge_coordinate(relative_move, current_file, current_rank)
        [(relative_move[0] + current_file.ord).chr, relative_move[1] + current_rank].join
    end
end