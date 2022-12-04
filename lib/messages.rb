module Messages
    def invalid_message(error)
        {
            'order'=>"The move you mentioned can't be perceived, follow the order:"\
                    "piece, origin_info(optional), destination square(N-b-d7)\n",
            'selection'=> "The piece you are trying to move could not be selected, try "\
                        "to select with more clarity \n",
            'invalid'=>"The move you made is invalid \n",
            'ambigous'=>"The move you made is ambigous, more than one intended piece can"\
                        " land there \n"
                    
        }[error]
    end
end