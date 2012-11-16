# encoding: utf-8

require 'screen'

module Screens
  class Text < Screen
    attr_accessor :keys, :text

    def initialize(options)
      @keys = options.fetch(:keys)
      @text = options.fetch(:text)
    end

    def rendered
      lines = @text.split("\n")

      ljust("", Black)+
      lines.map { |line| ljust(line, White) }.join+
      ljust("", White)*(screen_height-lines.size-2)+
      key_map_help(@keys)
    end
  end
end
