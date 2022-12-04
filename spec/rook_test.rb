require_relative '../lib/rook.rb'

describe Rook do
    context 'check for valid movement of rook' do
     
        it 'returns true when rook is on f1 and destination is a6' do
            rook = Rook.new('something', 'something')
            expect(rook.movement_possible?('f1','a6')).to be false
        end

        it 'returns true when rook is on a1 and destination is a8' do
            rook = Rook.new('something', 'something')
            expect(rook.movement_possible?('a1','a8')).to be true
        end

        it 'returns true when rook is on b8 and destination is c7' do
            rook = Rook.new('something', 'something')
            expect(rook.movement_possible?('b8','c7')).to be false
        end

        it 'returns true when rook is on e4 and destination is c7' do
            rook = Rook.new('something', 'something')
            expect(rook.movement_possible?('e4','c7')).to be false
        end
    end

end