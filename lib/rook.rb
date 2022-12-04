require_relative 'abstract_piece'

class Rook < Abstract_Piece
  UNIT_LENGTH = 1

  attr_reader :color, :piece_id, :rendered, :relative_moves, :board

  def initialize(color, piece_id, board)
    @color = color
    @piece_id = piece_id
    @rendered = piece(color)
    @relative_moves = []
    @board = board
  end

  def piece(color)
    { white: '♖', black: '♜' }[color]
  end

  def unit_relative_movement
    { [0, 1] => 8, [1, 0] => 'h'.ord, [0, -1] => 1, [-1, 0] => 'a'.ord }
  end

  def available_linear_squares(current_file, current_rank)
    subtractor = [current_file.ord, current_rank, current_file.ord, current_rank]
    unit_relative_movement.each do |unit_relative_move, bound|
      linear_length = (bound - subtractor.last).abs
      subtractor.pop
      UNIT_LENGTH.upto(linear_length) do |multiplier|
        @relative_moves << unit_relative_move.map { |i| i * multiplier }
        if board.square_available?(forge_coordinate(relative_moves.last, current_file, current_rank)) == false
          @relative_moves.pop
          break
        end
      end
    end
  end

  def forge_coordinate(relative_move, current_file, current_rank)
    [(relative_move[0] + current_file.ord).chr, relative_move[1] + current_rank].join
  end

  def potential_squares(slashed_coordinate)
    current_file = slashed_coordinate[0]
    current_rank = slashed_coordinate[1].to_i
    available_linear_squares(current_file, current_rank)
    relative_moves.map do |relative_move|
      forge_coordinate(relative_move, current_file, current_rank)
    end
  end
end
