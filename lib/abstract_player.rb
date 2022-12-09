require_relative 'messages.rb'
require_relative 'move_parser.rb'
require 'pry-byebug'

class Abstract_Player

    include Messages
    include Move_Parser

    attr_reader :last_moved_piece,  :from1, :rep1, :last_captured_piece, :from2, :rep2

    def input
        move = ''
        loop do
            move = gets.chomp
            break if is_valid?(move)
            print invalid_message('order') 
        end
        move
    end

    def fetch_squares(piece_id, origin_info)
        #initializing origin to '', if nil, which is guaranteed to be true
        origin_info = origin_info || ''
        pieces = board.grid.\
        filter{|coordinate, data| data[:piece] != nil && data[:piece].piece_id == piece_id && data[:piece].color == @self_color && coordinate.to_s.match?(origin_info) }
        return pieces unless pieces.length == 0
        print invalid_message('selection')
        nil
    end

    def capture(squares, destination)
    
        if board.grid[destination][:piece] != nil && board.grid[destination][:piece].color == @opposition_color &&\
            board.grid[destination][:piece].piece_id != :K 
            squares = squares.filter do |current_coordinate, square_data|
                square_data[:piece].capture_possible?(current_coordinate, destination)
            end
        else
            squares = {}
        end
        squares
    end

    def valid_destination(squares, destination)
        squares = squares.filter do |current_coordinate, square_data|
            square_data[:piece].movement_possible?(current_coordinate, destination)
        end
        squares
    end

    def check?(squares,destination)
        return squares unless squares.length == 1 
        piece_current = board.grid[squares.keys[0]][:piece]
        piece_destination = board.grid[destination][:piece]  
        board.grid[destination][:piece] = piece_current
        board.grid[squares.keys[0]][:piece] = nil
        bool1 = board.grid[king_coordinate[1]][:piece].check?(king_coordinate[1])
        bool2 = board.grid[king_coordinate[0]][:piece].check?(king_coordinate[0])
        board.grid[destination][:piece] = piece_destination
        board.grid[squares.keys[0]][:piece] = piece_current
        bool1||bool2
    end

    def king_coordinate
        self_king = ''
        opponent_king = ''
        king_coordinates = board.grid.\
        filter{|coordinate, data| data[:piece] != nil && data[:piece].piece_id == :K  }
        opponent_king_data = king_coordinates.each do |coordinate, data| 
            self_king = coordinate if data[:piece].color == @self_color
            opponent_king = coordinate if data[:piece].color == @opposition_color
        end
        [self_king, opponent_king]
    end

    def register_move(length, destination, squares)
        case length
        when 1
            board.moves << squares.keys[0] 
            move_piece(squares.keys[0], destination)
            delete_piece(squares.keys[0])
        when 0 
            print invalid_message('invalid')
        else
            print invalid_message('ambigous')
        end
    end

    def register_capture(selected_squares, destination)
        case selected_squares.length
        when 1 
            board.moves << selected_squares.keys[0]
            move_piece(selected_squares.keys[0], destination)
            delete_piece(selected_squares.keys[0])
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

    def move
        loop do
            parsed_data = parse(input)
            piece_id, origin_info,capture_info, destination,check_info = parsed_data[0],parsed_data[1],parsed_data[2], parsed_data[3], parsed_data[4]
            selected_squares = fetch_squares(piece_id, origin_info)
            next if selected_squares == nil

            if capture_info.nil? && check_info.nil?
                selected_squares = valid_destination(selected_squares,destination)
                selected_squares = {} if check?(selected_squares, destination)
                register_move(selected_squares.length,destination,selected_squares)
                selected_squares.length == 1 ? break : next

            elsif capture_info && check_info.nil?
                selected_squares = capture(selected_squares, destination)
                selected_squares = {} if check?(selected_squares, destination)
                register_capture(selected_squares, destination)
                selected_squares.length == 1 ? break : next

            elsif  capture_info.nil? && check_info  
                selected_squares = valid_destination(selected_squares,destination)
                selected_squares = {} if check?(selected_squares, destination) == false
                #check_for_checkmate
                register_move(selected_squares.length,destination,selected_squares)
                selected_squares.length == 1 ? break : next

            elsif  capture_info && check_info
                selected_squares = capture(selected_squares, destination)
                selected_squares = {} if check?(selected_squares, destination) == false
                #check_for_checkmate
                register_capture(selected_squares, destination)
                selected_squares.length == 1 ? break : next                                                                                                                                      
            end
        end
    end

end