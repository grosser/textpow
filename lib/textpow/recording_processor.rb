module Textpow
  class RecordingProcessor
    attr_accessor :stack

    def initialize
      @stack = []
    end

    def method_missing(name, *args)
      @stack << [name, *args]
    end
  end
end
