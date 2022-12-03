require_relative 'knight.rb'
require_relative 'move_parser.rb'
require_relative 'messages.rb'
require_relative 'abstract_player.rb'

class Player_White < Abstract_Player

    include Move_Parser

    def move(board)
        loop do
            parsed_data = parse(input)
            piece_id, origin, destination = parsed_data[0],parsed_data[1], parsed_data[2]
            selected_squares = fetch_squares(board,piece_id, origin, :white)
            next if selected_squares == nil
            selected_squares = valid_destination(board,selected_squares,destination)
            register_move(board,selected_squares.length,destination,selected_squares)
            break if selected_squares.length == 1
        end
    end

end