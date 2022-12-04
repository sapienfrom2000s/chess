require_relative '../lib/bishop.rb'

describe Bishop do
    context 'check for valid movement of bishop' do
     
        it 'returns true when bishop is on f1 and destination is a6' do
            bishop = Bishop.new('something', 'something')
            expect(bishop.movement_possible?('f1','a6')).to be true
        end

        it 'returns true when bishop is on a1 and destination is a8' do
            bishop = Bishop.new('something', 'something')
            expect(bishop.movement_possible?('a1','a8')).to be false
        end

        it 'returns true when bishop is on b8 and destination is c7' do
            bishop = Bishop.new('something', 'something')
            expect(bishop.movement_possible?('b8','c7')).to be true
        end

        it 'returns true when bishop is on e4 and destination is c7' do
            bishop = Bishop.new('something', 'something')
            expect(bishop.movement_possible?('e4','c7')).to be false
        end
    end

end