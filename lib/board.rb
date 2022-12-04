require 'colorize'

class Board
  attr_accessor :grid

  START_FILE = 'a'
  END_FILE = 'h'
  START_RANK = 1
  END_RANK = 8

  def initialize
    @grid = {}
    make_grid
  end

  def dark_square
    '   '.colorize(background: :green)
  end

  def light_square
    '   '.colorize(background: :yellow)
  end

  def make_grid

    END_RANK.downto START_RANK do |rank|
      
      START_FILE.upto END_FILE do |file|
        coordinate = file.concat(rank.to_s)
        @grid[coordinate] = {}
        @grid[coordinate][:position] = 8 * (rank - 1) + (file.ord - 96)
        @grid[coordinate][:piece] = nil
        if (@grid[coordinate][:position] + rank).even? 
          @grid[coordinate][:square] = dark_square
        else
          @grid[coordinate][:square] = light_square
        end
      end
    end
  end

  def display
    board = "\n"
    grid.each_value do |val|
      board += val[:square]
      board += "\n" if (val[:position] % 8).zero?
    end
    board+"\n"
  end
end

# board = Board.new
# print board.display
