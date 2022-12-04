class Abstract_Piece
    def movement_possible?(current_coordinate, destination)
        a = potential_squares(current_coordinate.split(''))
        a.any?{|potential_square|  potential_square == destination }
    end
end