class List
  @list = nil
  attr_accessor :list

  def initialize(list)
    @list = list
  end
  def get_length
    @list.length
  end

  def first_value
    @list[0]
  end

  def last_value
    @list[@list.length - 1]
  end

  def remove_value(idx)
    @list.delete_at(idx)
  end

  def get_range(start, stop)
    @list[start, stop]
  end

end