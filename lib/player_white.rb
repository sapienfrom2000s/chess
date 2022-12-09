require_relative 'move_parser.rb'
require_relative 'abstract_player.rb'

class Player_White < Abstract_Player

    include Move_Parser

    attr_reader :board, :self_color, :opposition_color

    def initialize(board)
        @board = board
        @self_color = :white
        @opposition_color = :black
    end

end