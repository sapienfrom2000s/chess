class Piece
    attr_reader :white, :black

    def initialize
        @white = { king:'♔', queen:'♕', rook:'♖', bishop:'♗', knight:'♘', pawn:'♙' }
        @black = { king:'♚', queen:'♛', rook:'♜', bishop:'♝', knight:'♞', pawn:'♟' }
    end

end