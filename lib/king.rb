require_relative 'abstract_piece'

class King < Abstract_Piece
  attr_reader :color, :piece_id, :rendered, :board

  def initialize(color, piece_id, board)
    @color = color
    @piece_id = piece_id
    @rendered = piece(color)
    @board = board
  end

  def piece(color)
    { white: '♔', black: '♚' }[color]
  end

  def relative_moves
    [[0, 1], [1, 0], [0, -1], [-1, 0], [1,1], [1,-1], [-1,-1], [-1,1]]
  end

  def potential_squares(slashed_coordinate)
    current_file = slashed_coordinate[0]
    current_rank = slashed_coordinate[1].to_i
    all_squares = relative_moves.filter do |relative_move|
      (relative_move[0] + current_file.ord).chr.between?('a', 'h') && (relative_move[1] + current_rank).between?(1, 8)
    end.map do |relative_move|
      forge_coordinate(relative_move, current_file, current_rank)
    end
    yield(all_squares) if block_given?
    possible_squares = all_squares.filter \
    { |coordinate| board.square_available?(coordinate) }
  end

  def capture_possible?(current_coordinate, destination)
    a = potential_squares(current_coordinate) do |all_squares|
      return all_squares.include?(destination) 
    end
  end

end
