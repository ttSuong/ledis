
class MyTimer
  attr_accessor :expired_time

  def initialize
    @timer = nil
  end

  def set_timeout (expired_time)
    @timer = expired_time
  end

  def get_timeout
    @timer
  end

  def is_expired
    if @timer
      @timer - Time.now < 0
    else
      false
    end
  end

end