class CountdownController < UIViewController
  extend IB

  attr_accessor :countdownMinutes, :countdownSeconds

  outlet :previewView, UIView
  outlet :previewImageView, UIImageView
  outlet :previewLabel, UILabel
  outlet :outputStatusLabel, UILabel
  outlet :lengthLabel, UILabel
  
  outlet :countdownLengthView, UIView
  outlet :minutesTextField, UITextField
  outlet :secondsTextField, UITextField

  outlet :startButton, UIButton
  outlet :stopButton, UIButton
  outlet :resetButton, UIButton

  attr_accessor :outputVC

  def viewDidLoad

    super

    @countdown = CountdownTimer.sharedClient
    @appearance = Appearance.sharedClient

    NSBundle.mainBundle.loadNibNamed("CountdownLengthView", owner:self, options:nil)
    @countdownLengthView.alpha = 0
    self.view.addSubview(@countdownLengthView)

    @countdownMinutes = 5
    @countdownSeconds = 0

    updateCountdownLength

    @minutesTextField.delegate = self
    @secondsTextField.delegate = self

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

  def viewWillLayoutSubviews

    super

    if UIScreen.mainScreen.bounds.size.height < 568
      @countdownLengthView.frame = CGRectMake(0, CGRectGetMaxY(@previewView.frame) - 36, self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(@previewView.frame) - 180)
    else
      @countdownLengthView.frame = CGRectMake(0, CGRectGetMaxY(@previewView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(@previewView.frame) - 216)
    end

  end

  def viewWillAppear(animated)

    super

    @previewView.backgroundColor = @appearance.backgroundColor
    @previewImageView.image = @appearance.backgroundImage
    @previewLabel.setFont(UIFont.fontWithName(@appearance.fontName, size:(@appearance.fontScale * @previewLabel.frame.size.width)))
    @previewLabel.textColor = @appearance.textColor

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

    @startButton.enabled = false
    @stopButton.enabled = true
    @resetButton.enabled = true

  end

  def stop

    @countdown.stop

    @startButton.enabled = true
    @stopButton.enabled = false
    @resetButton.enabled = true

  end

  def reset

    updateCountdownLength
    @countdown.reset

    @startButton.enabled = true
    @stopButton.enabled = false
    @resetButton.enabled = false

  end

  def plusOneMinute

    @countdown.addToRemaining(60)
    @resetButton.enabled = true

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

  def countdownHasFinished

    @startButton.enabled = false
    @stopButton.enabled = false
    @resetButton.enabled = true 

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