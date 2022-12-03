require_relative 'board.rb'
require_relative 'player_white.rb'
require_relative 'setup.rb'

require 'pry-byebug'

class Gameplay

    def initialize
        @board = Board.new
        print @board.display
        setup = Setup.new(@board)
        setup.init_knights
        print @board.display
        @player_white = Player_White.new(@board)
    end

    def play
        loop do
            @player_white.move
            print @board.display
            binding.pry
            @player_white.move
            print @board.display
        end
    end
end

game = Gameplay.new
game.play