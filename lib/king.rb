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

  def potential_squares(coordinate)
    current_file = coordinate[0]
    current_rank = coordinate[1].to_i
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
      return all_squares.include?(destination) && check?(destination) == false
    end
  end

  def movement_possible?(current_coordinate, destination)
    potential_squares = potential_squares(current_coordinate)
    potential_squares.any?{|potential_square|  (potential_square == destination) && check?(destination) == false }
  end

  def potential_captures(coordinate)
    captures = []
    potential_squares(coordinate) do |all_coordinates|
      all_coordinates.each do |coord|
        captures << coord if board.grid[coord][:piece] != nil && board.grid[coord][:piece].color != color &&\
                  board.grid[coord][:piece].piece_id != :K  && check?(coord) == false       
      end
      return captures
    end
  end


  def check?(destination)
    piece_destination = board.grid[destination][:piece]
    board.grid[destination][:piece] = nil
    opponent_piece_squares = board.grid.filter do |square, data|
      data[:piece] != nil && data[:piece].color != color && data[:piece].piece_id != :P
    end
    opponent_pawn_squares = board.grid.filter do |square, data|
      data[:piece] != nil && data[:piece].color != color && data[:piece].piece_id == :P
    end
    flag_piece = opponent_piece_squares.any? do |coordinate, data|
      board.grid[coordinate][:piece].potential_squares(coordinate).include?(destination)
    end
    flag_pawn = opponent_pawn_squares.any? do |coordinate, data|
      board.grid[coordinate][:piece].capture_possible?(coordinate, destination)
    end
    board.grid[destination][:piece] = piece_destination
    flag_piece || flag_pawn
  end

end
