# frozen_string_literal: true

require 'vvs/line'
require 'vvs/station'
require 'json'

module VVS
  class LinesParser
    def parse(string)
      JSON.parse(string)['lines'].map do |line|
        product_name = line['product']['name']

        if product_name == 'S-Bahn'
          Line.new(line['id'], line['disassembledName'])
        end
      end.compact.reject do |line|
        /vvs:\d+:.:R/.match(line.id) # do not present Rueckfahrt
      end.compact.reject do |line|
        # Do not present special case S60 Boeblingen - Renningen
        # because it is already covered by S60 Boeblingen - Schwabstrasse
        # vvs:10060: :H:j17:14
        # vvs:10060: :R:j17:14
        line.id.end_with?(':14')
      end.compact.reject do |line|
        # TODO: Somehow adding this line breaks the Concourse UI
        line.name == 'S60'
      end.reject
    end
  end

  class StationsParser
    def parse(string)
      JSON.parse(string)['locationSequence'].map do |line|
        Station.new(line['id'], line['name'])
      end
    end
  end
end
