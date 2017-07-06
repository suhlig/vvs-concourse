# frozen_string_literal: true

require 'vvs/line'
require 'vvs/station'

describe VVS::Line do
  # https://de.wikipedia.org/wiki/U-Bahn-Linie_1_(Berlin)
  subject(:wt) { VVS::Station.new('wt', 'Wittenbergplatz') }
  let(:kfo) { VVS::Station.new('kfo', 'Kurfürstendamm') }
  let(:u1) { VVS::Line.new('BVB:U001', 'U1') }

  before do
    u1.stations << wt
    u1.stations << kfo
    wt.lines << u1
    kfo.lines << u1
  end

  it 'can be compared' do
    expect(wt).to eq(VVS::Station.new('wt', 'Wittenbergplatz'))
  end

  context 'U1' do
    context 'at Kurfürstendamm' do
      it 'knows the previous station' do
        expect(u1.previous_station(kfo)).to eq(wt)
      end
    end
  end
end
