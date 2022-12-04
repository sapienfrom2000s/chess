require_relative 'abstract_piece.rb'

class Knight < Abstract_Piece

    attr_reader :color, :piece_id, :rendered, :relative_moves

    def initialize(color, piece_id)
        @color = color
        @piece_id = piece_id
        @rendered = piece(color)
        init_relative_movement
    end

    def piece(color)
        {white: '♘', black: '♞'}[color]
    end

    def init_relative_movement
        @relative_moves = [[-1,2],[1,2],[2,1],[2,-1],[1,-2],[-1,-2],[-2,-1],[-2,1]]
    end

    def potential_squares(slashed_coordinate)
        current_file = slashed_coordinate[0]
        current_rank = slashed_coordinate[1].to_i
        relative_moves.filter do |relative_move|
            (relative_move[0]+current_file.ord).chr.between?('a','h') && (relative_move[1]+current_rank).between?(1,8)
        end.map { |relative_move| [(relative_move[0]+current_file.ord).chr, (relative_move[1]+current_rank)].join }
    end
end