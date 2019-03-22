class Set
  @set = []
  attr_accessor :set

  def initialize(set)
    @set = set.uniq
  end

  def card
    @set.length
  end

  def member
    @set[0, @set.length]
  end

  def remove_member(value)
    value.each do |v|
      @set.delete(v)
    end
  end

  def &(other)
    puts @set
    puts other.set
    @set & other.set
  end

end