require_relative '../lib/knight.rb'

describe Knight do
    
    context 'when knights are initialized' do

    xit 'returns true if knight can move from f1 to d2' do
        knight = Knight.new('bla','bla')
        expect(knight.movement_possible?('f1','d2')).to be true
    end

    xit 'returns true if knight can move from h1 to h7' do
        knight = Knight.new('bla','bla')
        expect(knight.movement_possible?('h1','h7')).to be false
    end

    xit 'returns true if knight can move from h7 to h8' do
        knight = Knight.new('bla','bla')
        expect(knight.movement_possible?('h7','h8')).to be false
    end

    xit 'returns true if knight can move from e4 to f6' do
        knight = Knight.new('bla','bla')
        expect(knight.movement_possible?('e4','f6')).to be  true
    end

    xit 'returns true if knight can move from d8 to f7' do
        knight = Knight.new('bla','bla')
        expect(knight.movement_possible?('d8','f7')).to be true
    end

    it 'returns true if knight can move from a8 to h7' do
        knight = Knight.new('bla','bla')
        expect(knight.movement_possible?('a8','h7')).to be false
    end

  end
end