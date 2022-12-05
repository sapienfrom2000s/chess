require_relative 'abstract_piece'
require 'pry-byebug'

class Pawn < Abstract_Piece
  attr_reader :color, :piece_id, :rendered, :relative_moves, :board

  def initialize(color, piece_id, board)
    @color = color
    @piece_id = piece_id
    @rendered = piece(color)
    @board = board
    init_relative_movement
  end

  def piece(color)
    { white: '♙', black: '♟' }[color]
  end

  def init_relative_movement
    color == :white ? @relative_moves = [[0,1]] : @relative_moves = [[0,-1]] 
  end

  def potential_squares(slashed_coordinate)
    current_file = slashed_coordinate[0]
    current_rank = slashed_coordinate[1].to_i
    relative_moves.reject do |relative_move|
      current_rank == 8 || current_rank == 1
    end.map do |relative_move|
      forge_coordinate(relative_move, current_file, current_rank)
    end.filter \
    { |coordinate| board.square_available?(coordinate) }
  end

  def movement_possible?(current_coordinate, destination)
    a = potential_squares(current_coordinate.split(''))
    if (current_coordinate[1] == '2' && board.grid[current_coordinate][:piece].color == :white)\
        && (a.empty? == false)
        a << potential_squares(a[0].split(''))
    elsif(current_coordinate[1] == '7' && board.grid[current_coordinate][:piece].color == :black)\
        && (a.empty? == false)
        a << potential_squares(a[0].split(''))
    end
    a.flatten.any?{|potential_square|  potential_square == destination }    
  end
end


