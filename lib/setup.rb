require_relative 'knight'
require_relative 'bishop'
require_relative 'rook'
require_relative 'board'
require_relative 'queen'
require_relative 'pawn'
require_relative 'king'
require 'pry-byebug'

class Setup

    attr_reader :board

    def initialize(board)
        @board = board
    end

    def init_knights
        knights = []
        {'b1'=>:white,'g1'=>:white,'b8'=>:black,'g8'=>:black}.each_with_index do |(coordinate, color), index|
            knights << Knight.new(color,:N, board)
            board.grid[coordinate][:piece] = knights[index]
            board.grid[coordinate][:square][11] = knights[index].rendered
        end
    end

    def init_bishops
        bishops = []
        {'c1'=>:white,'f1'=>:white,'c8'=>:black,'f8'=>:black}.each_with_index do |(coordinate, color), index|
            bishops << Bishop.new(color, :B, board)
            board.grid[coordinate][:piece] = bishops[index]
            board.grid[coordinate][:square][11] = bishops[index].rendered
        end
    end

    def init_rooks
        rooks = []
        {'a1'=>:white,'h1'=>:white,'a8'=>:black,'h8'=>:black}.each_with_index do |(coordinate, color), index|
            rooks << Rook.new(color, :R, board)
            board.grid[coordinate][:piece] = rooks[index]
            board.grid[coordinate][:square][11] = rooks[index].rendered
        end
    end

    def init_queens
        queens = []
        {'d1'=>:white,'d8'=>:black}.each_with_index do |(coordinate, color), index|
            queens << Queen.new(color, :Q, board)
            board.grid[coordinate][:piece] = queens[index]
            board.grid[coordinate][:square][11] = queens[index].rendered
        end
    end

    def init_pawns
        pawns = []
        pawns_hash.each_with_index do |(coordinate, color), index|
            pawns << Pawn.new(color, :P, board)
            board.grid[coordinate][:piece] = pawns[index]
            board.grid[coordinate][:square][11] = pawns[index].rendered
        end
    end

    def init_kings
        kings = []
        {'e1'=>:white,'e8'=>:black}.each_with_index do |(coordinate, color), index|
            kings << King.new(color, :K, board)
            board.grid[coordinate][:piece] = kings[index]
            board.grid[coordinate][:square][11] = kings[index].rendered
        end
    end

    def pawns_hash
        pawn_data = {} 
        'a'.upto('h') do |file|
          pawn_data[[file,2].join] = :white  
          pawn_data[[file,7].join] = :black
        end
        pawn_data
    end

end 
