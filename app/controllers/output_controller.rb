class OutputController < UIViewController
  extend IB

  # attr_accessor :timeLabel
  outlet :timeLabel, UILabel
  outlet :backgroundImageView, UIImageView

  def viewDidLoad

    super

    @appearance = Appearance.sharedClient

  end

  def viewWillAppear(animated)

    super

    updateAppearance

  end

  def updateAppearance

    @backgroundImageView.image = @appearance.backgroundImage
    @timeLabel.setFont(UIFont.fontWithName("AvenirNext-UltraLight", size:(@appearance.fontScale * self.view.frame.size.width)))

  end

end