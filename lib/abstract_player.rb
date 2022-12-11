require_relative 'messages.rb'
require_relative 'move_parser.rb'
require 'pry-byebug'

class Abstract_Player

    include Messages
    include Move_Parser

    attr_reader :move

    def input
        move = ''
        loop do
            move = gets.chomp
            break if is_valid?(move)
            print invalid_message('order') 
        end
        @move = move
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


    #combine these two functions into one
    def check_opponent?(squares,destination)
        return false unless squares.length == 1 
        piece_current = board.grid[squares.keys[0]][:piece]
        piece_destination = board.grid[destination][:piece]  
        board.grid[destination][:piece] = piece_current
        board.grid[squares.keys[0]][:piece] = nil
        bool = board.grid[king_coordinate[1]][:piece].check?(king_coordinate[1])
        board.grid[destination][:piece] = piece_destination
        board.grid[squares.keys[0]][:piece] = piece_current
        bool
    end

    def check_self?(squares, destination)
        return false unless squares.length == 1 
        piece_current = board.grid[squares.keys[0]][:piece]
        piece_destination = board.grid[destination][:piece]  
        board.grid[destination][:piece] = piece_current
        board.grid[squares.keys[0]][:piece] = nil
        bool = board.grid[king_coordinate[0]][:piece].check?(king_coordinate[0])
        board.grid[destination][:piece] = piece_destination
        board.grid[squares.keys[0]][:piece] = piece_current
        bool
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

    def register_move(destination, squares)
        case squares.length
        when 1
            board.moves << @move
            move_piece(squares.keys[0], destination)
            delete_piece(squares.keys[0])
        when 0 
            print invalid_message('invalid')
        else
            print invalid_message('ambigous')
        end
    end

    def register_capture(squares, destination)
        case squares.length
        when 1 
            board.moves << @move
            move_piece(squares.keys[0], destination)
            delete_piece(squares.keys[0])
        when 0
            print invalid_message('capture')
        else
            print invalid_message('ambigous-capture')
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
            if board.moves.empty? == false && board.moves.last.split('').last == '+'
                if all_valid_moves.empty?
                    puts "#{@opposition_color.to_s.capitalize} Wins! "
                    exit(0)
                end
            end

            parsed_data = parse(input)
            piece_id, origin_info,capture_info, destination,check_info = parsed_data[0],parsed_data[1],parsed_data[2], parsed_data[3], parsed_data[4]
            selected_squares = fetch_squares(piece_id, origin_info)
            next if selected_squares == nil

            if capture_info.nil? && check_info.nil?
                selected_squares = valid_destination(selected_squares,destination)
                selected_squares = {} if check_opponent?(selected_squares, destination) || check_self?(selected_squares, destination)
                register_move(destination,selected_squares)
                selected_squares.length == 1 ? break : next

            elsif capture_info && check_info.nil?
                selected_squares = capture(selected_squares, destination)
                selected_squares = {} if check_opponent?(selected_squares, destination) || check_self?(selected_squares, destination)
                register_capture(selected_squares, destination)
                selected_squares.length == 1 ? break : next

            elsif  capture_info.nil? && check_info  
                selected_squares = valid_destination(selected_squares,destination)
                selected_squares = {} unless check_opponent?(selected_squares,destination) && check_self?(selected_squares,destination)==false
                register_move(destination,selected_squares)
                selected_squares.length == 1 ? break : next

            elsif  capture_info && check_info
                selected_squares = capture(selected_squares, destination)
                selected_squares = {} unless check_opponent?(selected_squares,destination) && check_self?(selected_squares,destination)==false
                register_capture(selected_squares, destination)
                selected_squares.length == 1 ? break : next                                                                                                                                      
            end
        end
    end

    def all_valid_moves
        moves = []
        opponent_king = king_coordinate[1]
        self_king = king_coordinate[0]
        squares = board.grid.filter do |coordinate, data|
            board.grid[coordinate][:piece] != nil && board.grid[coordinate][:piece].color == @self_color
        end
        squares.each do |coordinate, data|
            data[:piece].potential_squares(coordinate).each do |destination| 
                moves << data[:piece].piece_id.to_s + coordinate + destination if (check_opponent?({coordinate=>data}, destination)==false &&\
                 check_self?({coordinate=>data},destination) == false)
                moves << data[:piece].piece_id.to_s + coordinate + destination + "+" if (check_opponent?({coordinate=>data}, destination) &&\
                 check_self?({coordinate=>data},destination) == false)
            end

            data[:piece].potential_captures(coordinate).each do |destination|
                moves << data[:piece].piece_id.to_s + coordinate + 'x' + destination if (check_opponent?({coordinate=>data}, destination)==false &&\
                 check_self?({coordinate=>data},destination) == false)
                moves << data[:piece].piece_id.to_s + coordinate + 'x' + destination + "+" if (check_opponent?({coordinate=>data}, destination) &&\
                 check_self?({coordinate=>data},destination) == false)                    
            end
        end 
        moves
    end
end