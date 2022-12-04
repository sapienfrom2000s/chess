require_relative 'knight.rb'
require_relative 'move_parser.rb'
require_relative 'messages.rb'
require_relative 'abstract_player.rb'

class Player_White < Abstract_Player

    include Move_Parser

    attr_reader :board, :color

    def initialize(board)
        @board = board
        @color = :white
    end

    def move
        loop do
            parsed_data = parse(input)
            piece_id, origin_info, destination = parsed_data[0],parsed_data[1], parsed_data[2]
            selected_squares = fetch_squares(piece_id, origin_info, color)
            next if selected_squares == nil
            selected_squares = valid_destination(selected_squares,destination)
            register_move(selected_squares.length,destination,selected_squares)
            break if selected_squares.length == 1
        end
    end

end