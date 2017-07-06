# frozen_string_literal: true

require 'vvs/station'

describe VVS::Station do
  subject(:wt) { VVS::Station.new('wt', 'Wittenbergplatz') }

  it 'can be compared' do
    expect(wt).to eq(VVS::Station.new('wt', 'Wittenbergplatz'))
  end
end
