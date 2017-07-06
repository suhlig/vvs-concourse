# frozen_string_literal: true

require 'vvs/network'

module VVS
  class NetworkBuilder
    def initialize(lines_fetcher, lines_parser, stations_fetcher, stations_parser)
      @lines_fetcher = lines_fetcher
      @lines_parser = lines_parser
      @stations_fetcher = stations_fetcher
      @stations_parser  = stations_parser
    end

    def build
      Network.new('VVS').tap do |network|
        lines.each do |line|
          stations(line).each do |station|
            network.add(station, line)
          end
        end
      end
    end

    def lines
      @lines_parser.parse(lines_json)
    end

    def stations(line)
      @stations_parser.parse(stations_json(line))
    end

    def lines_json
      @lines_fetcher.lines
    end

    def stations_json(line)
      @stations_fetcher.stations(line)
    end
  end
end
