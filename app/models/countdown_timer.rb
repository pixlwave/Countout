class CountdownTimer

  attr_accessor :delegate
  attr_reader :length, :remaining, :runTimer

  def self.sharedClient
    Dispatch.once { @instance ||= new }
    @instance
  end

  def initialize

    @remaining = 0
    @length = 0

  end

  def setTime(length)

    @length = length
    @remaining = length

  end

  def start

    stop if @runTimer
    @runTimer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"tick", userInfo:nil, repeats:true)

  end

  def stop

    @runTimer.invalidate if @runTimer
    @runTimer = nil

  end

  def tick

    @remaining -= 1
    @delegate.countdownHasChanged

    stop if @remaining == 0

  end

end