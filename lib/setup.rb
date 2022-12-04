require_relative 'knight.rb'
require_relative 'board.rb'

class Setup

    attr_reader :board

    def initialize(board)
        @board = board
    end

    def init_knights
        knights = []
        {'b1'=>:white,'g1'=>:white,'g8'=>:black,'b8'=>:black}.each_with_index do |(coordinate, color), index|
            knights << Knight.new(color,:N)
            board.grid[coordinate][:piece] = knights[index]
            board.grid[coordinate][:square][11] = knights[index].rendered
            #the property of pieces should not be the property of grid but of piece itself 
        end
    end

    # def init_bishops
    #     bishops = []
    #     {'c1'=>:white,'f1'=>:white,'c8'=>:black,'f8'=>:black}.each_with_index do |(coordinate, color), index|
    #         bishops << Bishop.new
    #         board.grid[coordinate][:piece_id] = :B
    #         board.grid[coordinate][:piece_object] = bishops[index]
    #         board.grid[coordinate][:piece_color] = color
    #         board.grid[coordinate][:square][11] = Bishop.piece(color)
    #     end
    # end
end 