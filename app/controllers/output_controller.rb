class OutputController < UIViewController
  extend IB

  outlet :timeLabel, UILabel
  outlet :backgroundImageView, UIImageView

  def viewDidLoad
    super

    @appearance = Appearance.sharedClient

  end

  def viewDidLayoutSubviews
    super

    updateAppearance

  end

  def updateAppearance

    self.view.backgroundColor = @appearance.backgroundColor
    @backgroundImageView.image = @appearance.backgroundImage
    @timeLabel.setFont(UIFont.fontWithName(@appearance.fontName, size:(@appearance.fontScale * self.view.frame.size.width)))
    @timeLabel.textColor = @appearance.textColor

  end

end