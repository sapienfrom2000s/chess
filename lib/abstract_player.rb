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

    def fetch_squares(board, piece_id, origin, color)
        #initializing origin to '' if nil, which is guaranteed to be true
        origin = origin || ''
        pieces = board.grid.\
        filter{|coordinate, data| data[:piece_id] == piece_id && data[:piece_color] == color && coordinate.to_s.match?(origin) }
        return pieces unless pieces.length == 0
        print invalid_message('selection')
        nil
    end

    def valid_destination(board, squares, destination)
        squares = squares.filter do |current_coordinate, square_data|
            square_data[:piece_object].movement_possible?(current_coordinate, destination)
        end
        squares
    end

#ordering below

    def register_move(board, length, destination, squares)
        case length
        when 1 
            move_piece(board,squares.keys[0], destination)
            delete_piece(board,squares.keys[0])
        when 0 
            print invalid_message('invalid')
        else
            print invalid_message('ambigous')
        end
    end

    def delete_piece(board,current_coordinate)
        board.grid[current_coordinate][:square][11] = ' '
        board.grid[current_coordinate][:piece_object] = nil
        board.grid[current_coordinate][:piece_color] = nil
        board.grid[current_coordinate][:piece_id] = nil
    end

    def move_piece(board, current_coordinate,destination)
        board.grid[destination][:square][11] = board.grid[current_coordinate][:square][11]
        board.grid[destination][:piece_object] = board.grid[current_coordinate][:piece_object]
        board.grid[destination][:piece_color] = board.grid[current_coordinate][:piece_color]
        board.grid[destination][:piece_id] = board.grid[current_coordinate][:piece_id]
    end

end