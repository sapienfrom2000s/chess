require_relative 'messages.rb'
require_relative 'move_parser.rb'
require 'pry-byebug'

class Abstract_Player

    include Messages
    include Move_Parser

    def input
        move = ''
        loop do
            move = gets.chomp
            break if is_valid?(move)
            print invalid_message('order') 
        end
        move
    end

    def fetch_squares(piece_id, origin_info, color)
        #initializing origin to '', if nil, which is guaranteed to be true
        origin_info = origin_info || ''
        pieces = board.grid.\
        filter{|coordinate, data| data[:piece] != nil && data[:piece].piece_id == piece_id && data[:piece].color == color && coordinate.to_s.match?(origin_info) }
        return pieces unless pieces.length == 0
        print invalid_message('selection')
        nil
    end

    def capture(squares, destination, opposition_color)
    
        if board.grid[destination][:piece] != nil && board.grid[destination][:piece].color == opposition_color &&\
             board.grid[destination][:piece].piece_id != :K 
            squares = squares.filter do |current_coordinate, square_data|
                square_data[:piece].capture_possible?(current_coordinate, destination)
            end
        else
            return {}
        end
        squares
    end

    def valid_destination(squares, destination)
        squares = squares.filter do |current_coordinate, square_data|
            square_data[:piece].movement_possible?(current_coordinate, destination)
        end
        squares
    end

    def register_move(length, destination, squares)
        case length
        when 1 
            move_piece(squares.keys[0], destination)
            delete_piece(squares.keys[0])
        when 0 
            print invalid_message('invalid')
        else
            print invalid_message('ambigous')
        end
    end

    def register_capture(potential_captures, destination)
        case potential_captures.length
        when 1 
            move_piece(potential_captures.keys[0], destination)
            delete_piece(potential_captures.keys[0])
        when 0
            print invalid_message('capture')
        else
            print invalid_message('ambigous capture')
        end
    end

    def delete_piece(current_coordinate)
        board.grid[current_coordinate][:square][11] = ' '
        board.grid[current_coordinate][:piece] = nil
    end

    def move_piece(current_coordinate,destination)
        board.grid[destination][:square][11] = board.grid[current_coordinate][:piece].rendered
        board.grid[destination][:piece] = board.grid[current_coordinate][:piece]
    end

    def move(opposition_color)
        loop do
            parsed_data = parse(input)
            piece_id, origin_info,capture_info, destination = parsed_data[0],parsed_data[1],parsed_data[2], parsed_data[3]
            selected_squares = fetch_squares(piece_id, origin_info, color)
            next if selected_squares == nil
            if capture_info
                potential_captures = capture(selected_squares, destination, opposition_color) if capture_info
                register_capture(potential_captures, destination)
                potential_captures.length == 1 ? break : next
            end 
            potential_destinations = valid_destination(selected_squares,destination)
            register_move(potential_destinations.length,destination,potential_destinations)
            break if potential_destinations.length == 1
        end
    end

end