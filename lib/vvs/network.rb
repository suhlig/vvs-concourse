# frozen_string_literal: true

module VVS
  class Network
    def initialize(name)
      @name = name
      @stations = {}
      @lines = {}
    end

    # TODO: Move this to NetworkBuilder
    def add(station, line)
      # add station to line
      l = @lines.fetch(line) do
        @lines[line] = line
      end

      l.stations << station unless l.stations.include?(station)

      # add line to station
      s = @stations.fetch(station) do
        @stations[station] = station
      end

      s.lines << l unless s.lines.include?(l)
    end

    def lines
      @lines.values
    end

    def stations
      @stations.values
    end

    def station(name)
      stations.find { |s| s.name == name }
    end

    def line(name)
      lines.find { |l| l.name == name }
    end
  end
end
