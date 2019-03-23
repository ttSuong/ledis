class MyString < MyTimer

  attr_accessor :string

  def initialize(string)
    @string = string
  end

  def get
    @string
  end

end