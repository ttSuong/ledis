require 'set'

class MySet < MyTimer
  attr_accessor :set

  def initialize(set)
    @set = Set.new(set)
  end

  def card
    @set.length
  end

  def member
    @set
  end

  def remove_member(value)
    @set = @set - Set.new(value)
  end

  def inter(other)
    MySet.new(@set & other.set)
  end

end
