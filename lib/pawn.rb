require_relative 'abstract_piece'
require 'pry-byebug'

class Pawn < Abstract_Piece
  attr_reader :color, :piece_id, :rendered, :board

  def initialize(color, piece_id, board)
    @color = color
    @piece_id = piece_id
    @rendered = piece(color)
    @board = board
  end

  def piece(color)
    { white: '♙', black: '♟' }[color]
  end

  def relative_moves
    color == :white ? @relative_moves = [[0,1]] : @relative_moves = [[0,-1]] 
  end

  def potential_squares(coordinate)
    current_file = coordinate[0]
    current_rank = coordinate[1].to_i
    all_squares = relative_moves.reject do |relative_move|
      current_rank == 8 || current_rank == 1
    end.map do |relative_move|
      forge_coordinate(relative_move, current_file, current_rank)
    end
    yield(all_squares) if block_given?
    available_squares = all_squares.filter \
    { |coordinate| board.square_available?(coordinate) }
  end

  def potential_captures(coordinate)
    current_file = coordinate[0]
    current_rank = coordinate[1].to_i
    captures = []
    pattern = /^[a-h][1-8]$/
    capture_possible?(coordinate,'h9') do |possible_captures|
      coords = possible_captures.filter{|coord| coord.match?(pattern)}.each do |coord|  
      captures << coord if board.grid[coord][:piece] != nil && board.grid[coord][:piece].color != color &&\
                  board.grid[coord][:piece].piece_id != :K
      end
    end
    captures
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

  def capture_possible?(current_coordinate, destination)
    #no need to eliminate ` and i file here as it's the last complexity
    a = potential_squares(current_coordinate) do |forward_coordinate|
      possible_captures = [[(forward_coordinate[0][0].ord-1).chr,forward_coordinate[0][1]].join, [(forward_coordinate[0][0].ord+1).chr,forward_coordinate[0][1]].join]
      yield(possible_captures) if block_given?
     return possible_captures.include?(destination)
    end
   end
end


