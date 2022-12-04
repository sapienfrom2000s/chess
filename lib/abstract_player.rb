require_relative 'messages.rb'
require_relative 'move_parser.rb'

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
        #initializing origin to '' if nil, which is guaranteed to be true
        origin_info = origin_info || ''
        pieces = board.grid.\
        filter{|coordinate, data| data[:piece] != nil && data[:piece].piece_id == piece_id && data[:piece].color == color && coordinate.to_s.match?(origin_info) }
        return pieces unless pieces.length == 0
        print invalid_message('selection')
        nil
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

    def delete_piece(current_coordinate)
        board.grid[current_coordinate][:square][11] = ' '
        board.grid[current_coordinate][:piece] = nil
    end

    def move_piece(current_coordinate,destination)
        board.grid[destination][:square][11] = board.grid[current_coordinate][:piece].rendered
        board.grid[destination][:piece] = board.grid[current_coordinate][:piece]
    end

end