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
        else
          warn "Ignoring #{product_name} #{line['id']}"
        end
      end.compact.reject! do |line|
        /vvs:\d+:.:R/.match(line.id) # do not present Rückfahrt
      end.compact.reject! do |line|
        # Do not present special case S60 Böblingen - Renningen
        # because it is already covered by S60 Böblingen - Schwabstraße
        # vvs:10060: :H:j17:14
        # vvs:10060: :R:j17:14
        line.id.end_with?(':14')
      end
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