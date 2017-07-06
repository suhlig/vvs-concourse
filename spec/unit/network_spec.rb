# frozen_string_literal: true

require 'vvs/network_builder'
require 'vvs/parser'
require 'vvs/fetcher'
require 'webmock/rspec'

describe VVS::Network do
  subject(:network) do
    VVS::NetworkBuilder.new(
      VVS::LinesFetcher.new,
      VVS::LinesParser.new,
      VVS::StationsFetcher.new,
      VVS::StationsParser.new
    ).build
  end

  before do
    stub_request(:get, 'https://www3.vvs.de/mngvvs/XML_SERVINGLINES_REQUEST?lineName=s&lineReqType=8&lsShowTrainsExplicit=1&mode=line&outputFormat=rapidJSON')
      .to_return(status: 200, body: fixture('lines.json').read, headers: {})

    [
      'vvs:10001: :H:j17:1', 'vvs:10002: :H:j17:1', 'vvs:10003: :H:j17:1',
      'vvs:10004: :H:j17:1', 'vvs:10005: :H:j17:1', 'vvs:10006: :H:j17:1',
      'vvs:10060: :H:j17:1', 'vvs:10060: :H:j17:14', 'vvs:31367:e:H:j17:1',
      'vvs:31367:e:R:j17:1'
    ].each do |id|
      stub_request(:get, "https://www3.vvs.de/mngvvs/XML_LINESTOP_REQUEST?line=#{id}&outputFormat=rapidJSON")
        .to_return(status: 200, body: fixture("stations/#{id}.json").read, headers: {})
    end
  end

  it 'has the expected lines' do
    expect(network.lines.size).to eq(7)
    expect(network.lines[0].name).to eq('S1')
    expect(network.lines[1].name).to eq('S2')
    expect(network.lines[2].name).to eq('S3')
    expect(network.lines[3].name).to eq('S4')
    expect(network.lines[4].name).to eq('S5')
    expect(network.lines[5].name).to eq('S6')
    expect(network.lines[6].name).to eq('S60')
  end

  context 'Line S1' do
    context 'station Neckarpark' do
      subject(:station) { network.station('Neckarpark') }

      it 'is served by one line' do
        expect(station.lines.size).to eq(1)
      end

      it 'is served by S1' do
        expect(station.lines.map(&:name)).to include('S1')
      end
    end

    context 'station Bad Cannstatt' do
      subject(:station) { network.station('Bad Cannstatt') }

      it 'is served by three lines' do
        expect(station.lines.size).to eq(3)
      end

      it 'is served by S1' do
        expect(station.lines.map(&:name)).to include('S1')
      end

      it 'is served by S2' do
        expect(station.lines.map(&:name)).to include('S2')
      end

      it 'is served by S3' do
        expect(station.lines.map(&:name)).to include('S3')
      end
    end
  end
end
