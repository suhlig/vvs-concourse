# frozen_string_literal: true

module VVS
  class Base
    attr_reader :id

    def initialize(id, name)
      raise 'ID must be present' if id.to_s.empty?
      @id = id
      @name = name
    end

    def name
      @name || id
    end

    def to_s
      "#{self.class.name} #{name}"
    end

    def inspect
      "#{self} (#{id})"
    end

    def hash
      id.hash
    end

    def eql?(other)
      hash == other.hash
    end

    def ==(other)
      id == other.id && name == other.name
    end
  end
end
