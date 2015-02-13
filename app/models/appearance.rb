class Appearance

  IAP = PM::IAP::Product.new("uk.pixlwave.Countout.appearance")
  
  attr_accessor :backgroundColor, :backgroundImage, :fontName, :fontScale, :fontWeight, :textColor

  def self.sharedClient
    Dispatch.once { @instance ||= new }
    @instance
  end

  def initialize

    @backgroundColor = Turnkey.unarchive("BackgroundColor") || UIColor.colorWithRed(0.0, green:0.0, blue:72.0/255.0, alpha:1.0)
    @backgroundImage = Turnkey.unarchive("BackgroundImage")
    @fontName = Turnkey.unarchive("FontName") || "AvenirNext"
    @fontScale = Turnkey.unarchive("FontScale") || 0.25
    @fontWeight = Turnkey.unarchive("FontWeight") || "UltraLight"
    @textColor = Turnkey.unarchive("TextColor") || UIColor.colorWithRed(1.0, green:1.0, blue:1.0, alpha:1.0)

  end

  def save

    Turnkey.archive(@backgroundColor, "BackgroundColor")
    Turnkey.archive(@backgroundImage, "BackgroundImage")
    Turnkey.archive(@fontName, "FontName")
    Turnkey.archive(@fontScale, "FontScale")
    Turnkey.archive(@fontWeight, "FontWeight")
    Turnkey.archive(@textColor, "TextColor")

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