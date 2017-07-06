# frozen_string_literal: true

require 'httpclient'
require 'uri'

module VVS
  module Fetcher
    class Base
      BASE_URI = 'https://www3.vvs.de/mngvvs'

      def fetch(query)
        r = HTTPClient.new.get(URI.encode("#{BASE_URI}/#{resource}?#{query}"))

        if r.code == 200
          r.body
        else
          raise "Error fetching URL: #{r.body}"
        end
      end
    end
  end

  class LinesFetcher < Fetcher::Base
    def resource
      'XML_SERVINGLINES_REQUEST'
    end

    def lines
      fetch('lineName=s&lineReqType=8&lsShowTrainsExplicit=1&mode=line&outputFormat=rapidJSON')
    end
  end

  class StationsFetcher < Fetcher::Base
    def resource
      'XML_LINESTOP_REQUEST'
    end

    def stations(line_or_id)
      id = if line_or_id.respond_to?(:id)
             line_or_id.id
           else
             line_or_id
           end

      fetch "line=#{id}&outputFormat=rapidJSON"
    end
  end
end
