class Appearance

  attr_accessor :backgroundColour, :backgroundImage, :fontColour, :font, :fontScale

  def self.sharedClient
    Dispatch.once { @instance ||= new }
    @instance
  end

  def initialize

    # load from defaults
    @fontScale = 0.25

  end

end