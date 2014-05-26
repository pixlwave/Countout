class OutputController < UIViewController
  extend IB

  # attr_accessor :timeLabel
  outlet :timeLabel, UILabel
  outlet :backgroundImageView, UIImageView

  def viewDidLoad

    @appearance = Appearance.sharedClient

  end

  def viewWillAppear(animated)

    updateAppearance

  end

  def updateAppearance

    @backgroundImageView.image = @appearance.backgroundImage
    @timeLabel.setFont(UIFont.fontWithName("AvenirNext-UltraLight", size:(256 / (1024 / self.view.frame.size.width))))

  end

  def countdownHasChanged

    remainingString = "#{(@countdown.remaining / 60).to_s}:#{(@countdown.remaining % 60).to_s.rjust(2,'0')}"
    @timeLabel.text = remainingString

  end

end