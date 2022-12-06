require 'pry-byebug'

class Abstract_Piece
    def movement_possible?(current_coordinate, destination)
        a = potential_squares(current_coordinate)
        puts a
        a.any?{|potential_square|  potential_square == destination }
    end

    def capture_possible?(current_coordinate, destination)
        current_file = splitter(current_coordinate)[0]
        current_rank = splitter(current_coordinate)[1].to_i
        destination_file = splitter(destination)[0]
        destination_rank = splitter(destination)[1]
        a = potential_squares(current_coordinate)
        unit_relative_movement.keys.filter do |relative_move|
            ((destination_file.ord - current_file.ord) < 0 && relative_move[0] < 0) &&\
            ((destination_rank - current_rank) < 0 && relative_move[1] < 0)
        end.map{|fileorrank| fileorrank*(-1)  }.map do |relative_move|
        forge_coordinate(relative_move, destination_file, destination_rank)
        end.any?\
        {|coordinate|  a.include?(coordinate) && (board.grid[coordinate].piece.nil? || board.grid[coordinate] == current_coordinate)}
    end

    def splitter(coordinate)
        split = coordinate.split('')
        [split[0],split[1]]
    end

    def forge_coordinate(relative_move, current_file, current_rank)
        [(relative_move[0] + current_file.ord).chr, relative_move[1] + current_rank].join
    end
end