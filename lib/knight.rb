require_relative 'abstract_piece'
require 'pry-byebug'

class Knight < Abstract_Piece
  attr_reader :color, :piece_id, :rendered, :relative_moves, :board

  def initialize(color, piece_id, board)
    @color = color
    @piece_id = piece_id
    @rendered = piece(color)
    @board = board
    init_relative_movement
  end

  def piece(color)
    { white: '♘', black: '♞' }[color]
  end

  def init_relative_movement
    @relative_moves = [[-1, 2], [1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1]]
  end

  def potential_squares(coordinate)
    current_file = coordinate[0]
    current_rank = coordinate[1].to_i
    all_squares = relative_moves.filter do |relative_move|
      (relative_move[0] + current_file.ord).chr.between?('a', 'h') && (relative_move[1] + current_rank).between?(1, 8)
    end.map do |relative_move|
      forge_coordinate(relative_move, current_file, current_rank)
    end
    yield(all_squares) if block_given?
    valid_squares = all_squares.filter \
    { |coordinate| board.square_available?(coordinate) }
  end

  def capture_possible?(current_coordinate, destination)
   a = potential_squares(current_coordinate) do |all_squares|
     return all_squares.include?(destination) 
   end
  end

  def potential_captures(coordinate)
    captures = []
    potential_squares(coordinate) do |all_coordinates|
      puts all_coordinates
      all_coordinates.each do |coord|
        captures << coord if board.grid[coord][:piece] != nil && board.grid[coord][:piece].color != color &&\
                  board.grid[coord][:piece].piece_id != :K         
      end
      return captures
    end
  end
end
