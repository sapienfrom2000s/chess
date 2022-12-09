require_relative 'move_parser.rb'
require_relative 'abstract_player.rb'

class Player_Black < Abstract_Player

    include Move_Parser

    attr_reader :board, :color

    def initialize(board)
        @board = board
        @self_color = :black
        @opposition_color = :white
    end

end