class Appearance

  attr_accessor :backgroundColor, :backgroundImage, :fontName, :fontScale, :fontWeight, :textColor

  def self.sharedClient
    Dispatch.once { @instance ||= new }
    @instance
  end

  def initialize

    # load from defaults
    @backgroundColor = UIColor.colorWithRed(0.0, green:0.0, blue:72.0/255.0, alpha:1.0)
    @fontName = "AvenirNext"
    @fontScale = 0.25
    @fontWeight = "UltraLight"
    @textColor = UIColor.colorWithRed(1.0, green:1.0, blue:1.0, alpha:1.0)

  end

  def reset

    @backgroundColor = UIColor.colorWithRed(0.0, green:0.0, blue:72.0/255.0, alpha:1.0)
    @backgroundImage = nil
    @fontName = "AvenirNext"
    @fontScale = 0.25
    @fontWeight = "UltraLight"
    @textColor = UIColor.colorWithRed(1.0, green:1.0, blue:1.0, alpha:1.0)

  end

  def fontName

    @fontName + "-" + @fontWeight

  end

end