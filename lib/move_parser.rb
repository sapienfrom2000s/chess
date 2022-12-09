# class Test
#     include Move_Parser
# end

module Move_Parser
    def is_valid?(move)
       pattern = /^(Q|K|N|B|R|P)(([a-h])|([1-8])|([a-h][1-8]))?(x)?([a-h][1-8])(\+)?$/
       pattern.match?(move)
    end

    def parse(move)
        data = (move.scan(/^(Q|K|N|B|R|P)(([a-h])|([1-8])|([a-h][1-8]))?(x)?([a-h][1-8])(\+)?$/))[0]
        piece_id = data.first.to_sym
        #takes the first truthy value
        origin_info = data[1]||data[2]||data[3]
        capture_info = data[5]
        destination = data[6]
        check_info = data.last
        [piece_id, origin_info,capture_info, destination, check_info ]
    end
end