# encoding: utf-8

require 'item'
require 'items/healingitem'

class Items
  include Enumerable

  def initialize(size, contents={})
    @contents = Hash.new(0).merge(contents)
    @size     = size
    @used     = 0
    @contents.each do |item, count|
      @used += item.size*count
    end
  end

  def add(item, count=1)
    @contents[item] += count
  end

  def remove(item, count=1)
    assert_has(item, count)
    @contents[item] -= 1
  end

  def order(property, direction=:asc)
    @contents.replace(@contents.sort_by { |k,v|
      v.__send__(property)
    })
  end

  def each(&block)
    @contents.each(&block)
  end

  def size
    @contents.size
  end

private

  def assert_has(item, count)
    raise "Not enough #{item} available" if @contents[item] < count
  end
end
