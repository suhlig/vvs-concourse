# frozen_string_literal: true

require 'vvs/fetcher'
require 'vvs/parser'
require 'vvs/network'
require 'vvs/station'
require 'vvs/line'

require 'yaml'

module Concourse
  module VVS
    class Pipeline
      def initialize(network)
        @network = network
      end

      def to_yaml
        resources = []
        groups = []
        add_self(resources)

        groups << create_network_group(@network.stations)

        @network.lines.each do |line|
          resources << create_resource(line)
          groups << create_line_group(line)
        end

        jobs = []
        @network.stations.each do |station|
          jobs << create_job(station)
        end

        {
          'resources' => resources,
          'groups' => groups,
          'jobs' => jobs
        }.to_yaml
      end

      private

      def create_network_group(stations)
        {
          'name' => 'Network',
          'jobs' => stations.map(&:name)
        }
      end

      def create_line_group(line)
        {
          'name' => line.name,
          'jobs' => line.stations.map(&:name)
        }
      end

      def create_resource(line)
        {
          'name' => line.name,
          'type' => 'time',
          'source' => { 'interval' => "#{rand(5..15)}m" }
        }
      end

      def create_job(station)
        {
          'name' => station.name,
          'plan' => [
            {
              'aggregate' => [
                { 'get' => 'pipeline', 'trigger' => true }
              ].concat(incoming_lines(station))
            },
            {
              'task'   => 'Halt',
              'file'   => 'pipeline/tasks/halt/task.yml',
              'params' => { 'station' => station.name }
            }
          ]
        }
      end

      def incoming_lines(station)
        station.lines.map do |line|
          {
            'get' => line.name,
            'trigger' => true
          }.tap do |result|
            begin
              previous_station = line.previous_station(station)

              if previous_station
                result['passed'] = [previous_station.name]
              end
            rescue
              warn $ERROR_INFO.message
            end
          end
        end
      end

      def add_self(resources)
        resources << {
          'name' => 'pipeline',
          'type' => 'git',
          'source' => {
            'uri' => 'https://github.com/suhlig/vvs-concourse',
            'branch' => 'master',
            'paths' => [
              'tasks/*'
            ]
          }
        }
      end
    end
  end
end
