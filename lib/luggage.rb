# encoding: utf-8

class Luggage
  include Enumerable

  def initialize(size, contents={})
    @contents = Hash.new(0).merge(contents)
    @ordered  = @contents.keys
    @size     = size
    @used     = 0
    @contents.each do |item, count|
      @used += item.size*count
    end
  end

  def amount(item)
    @contents[item]
  end

  def add(item, count=1)
    @contents[item] += count
  end

  def remove(item, count=1)
    assert_has(item, count)
    @contents[item] -= 1
  end

  def order!(property, direction=:asc)
    @ordered.sort_by! do |item|
      item.__send__(property)
    end

    self
  end

  def [](index_or_key)
    if index_or_key.is_a?(Integer)
      @ordered[index_or_key]
    else
      @contents[index_or_key]
    end
  end

  def each(&block)
    @ordered.each(&block)
  end

  def size
    @ordered.size
  end

private

  def assert_has(item, count)
    raise "Not enough #{item} available" if @contents[item] < count
  end
end
