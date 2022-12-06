require_relative 'move_parser.rb'
require_relative 'abstract_player.rb'

class Player_White < Abstract_Player

    include Move_Parser

    attr_reader :board, :color

    def initialize(board)
        @board = board
        @color = :white
    end

end