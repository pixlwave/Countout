class Appearance

  attr_accessor :backgroundColour, :backgroundImage, :fontColour, :font

  def self.sharedClient
    Dispatch.once { @instance ||= new }
    @instance
  end

  def initialize

    # load from defaults

  end

end