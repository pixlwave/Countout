class CountdownController < UIViewController
  extend IB

  attr_accessor :countdownMinutes, :countdownSeconds

  outlet :previewView, UIView
  outlet :previewImageView, UIImageView
  outlet :previewLabel, UILabel
  outlet :outputStatusLabel, UILabel
  outlet :lengthLabel, UILabel
  outlet :minutesTextField, UITextField
  outlet :secondsTextField, UITextField
  outlet :countdownLengthView, UIView

  outlet :countdownLengthViewTopConstraint, NSLayoutConstraint
  outlet :countdownDoneButtonTopConstraint, NSLayoutConstraint
  outlet :countdownLengthViewBottomConstraint, NSLayoutConstraint

  attr_accessor :outputVC

  def viewDidLoad

    @countdown = CountdownTimer.sharedClient
    @appearance = Appearance.sharedClient

    @countdownMinutes = 5
    @countdownSeconds = 0

    updateCountdownLength

    @minutesTextField.delegate = self
    @secondsTextField.delegate = self

    if UIScreen.mainScreen.bounds.size.height < 568
      @countdownLengthViewTopConstraint.constant = -36
      @countdownDoneButtonTopConstraint.constant = 15
      @countdownLengthViewBottomConstraint.constant = 0
    end

  end

  def preferredStatusBarStyle

    if UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone
      UIStatusBarStyleLightContent
    else
      UIStatusBarStyleDefault
    end
  
  end

  def supportedInterfaceOrientations

    if UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone
      UIInterfaceOrientationMaskPortrait
    else
      UIInterfaceOrientationMaskAll
    end

  end

  def viewWillAppear(animated)

    @previewImageView.image = @appearance.backgroundImage
    @previewLabel.setFont(UIFont.fontWithName("AvenirNext-UltraLight", size:(@appearance.fontScale * @previewLabel.frame.size.width)))

  end

  def updateCountdownLength

    length = @countdownMinutes.minutes + @countdownSeconds
    @countdown.setTime(length)

    UIApplication.sharedApplication.delegate.countdownHasChanged
    updateLengthLabel

  end

  def updateLengthLabel

    if @countdownMinutes == 1 then minutesSuffix = "minute" else minutesSuffix = "minutes" end
    if @countdownSeconds == 1 then secondsSuffix = "second" else secondsSuffix = "seconds" end
    @lengthLabel.text = "#{@countdownMinutes.to_s} #{minutesSuffix}"
    @lengthLabel.text += ", #{@countdownSeconds.to_s} #{secondsSuffix}" unless @countdownSeconds == 0

    # update the 
    @minutesTextField.text = @countdownMinutes.to_s
    @secondsTextField.text = @countdownSeconds.to_s

  end

  def start

    @countdown.start

  end

  def stop

    @countdown.stop

  end

  def reset

    updateCountdownLength
    @countdown.reset

  end

  def editCountdownLength

    @countdownLengthView.fade_in
    @minutesTextField.becomeFirstResponder

  end

  def finishCountdownLength

    self.view.endEditing(true)
    @countdownMinutes = @minutesTextField.text.to_i
    @countdownSeconds = @secondsTextField.text.to_i
    @countdownMinutes = 1 if @countdownMinutes + @countdownSeconds == 0

    if @countdown.active?
      updateLengthLabel   # only update countdown length label to reflect what reset will do
    else
      reset               # reset which updates countdown length and length label
    end

    # if @countdown.active? then updateLengthLabel else reset end

    @countdownLengthView.fade_out

  end


  #### text field delegate methods ####

  def textField(textField, shouldChangeCharactersInRange:range, replacementString:string)

    text = textField.text
    textField.text = "" if text.to_i == 0

    if textField == @secondsTextField

      return false if "#{text}#{string}".to_i > 59

    elsif textField == @minutesTextField

      return false if "#{text}#{string}".to_i > 999

    end

    true

  end

end