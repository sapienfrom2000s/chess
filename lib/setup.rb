require_relative 'knight.rb'
require_relative 'board.rb'

class Setup

    def init_knights(board)
        knights = []
        {'b1'=>:white,'g1'=>:white,'g8'=>:black,'b8'=>:black}.each_with_index do |(coordinate, color), index|
            knights << Knight.new
            board.grid[coordinate][:piece_id] = :N
            board.grid[coordinate][:piece_object] = knights[index]
            board.grid[coordinate][:piece_color] = color
            board.grid[coordinate][:square][11] = Knight.piece(color)
        end
    end
end 