require_relative 'board.rb'
require_relative 'player_white.rb'
require_relative 'player_black.rb'
require_relative 'setup.rb'

require 'pry-byebug'

class Gameplay

    attr_reader :player_white, :player_black, :board

    def initialize
        @board = Board.new
        setup = Setup.new(@board)
        setup.init_knights
        setup.init_bishops
        setup.init_rooks
        setup.init_queens
        setup.init_pawns
        setup.init_kings
        print @board.display
        @player_white = Player_White.new(@board)
        @player_black = Player_Black.new(@board)
    end

    def play
        loop do
            player_white.move
            print board.display
            player_black.move
            print board.display
        end
    end
end

game = Gameplay.new
game.play