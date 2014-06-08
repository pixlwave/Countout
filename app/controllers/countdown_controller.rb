class CountdownController < UIViewController
  extend IB

  attr_accessor :countdownMinutes, :countdownSeconds

  outlet :previewView, UIView
  outlet :previewImageView, UIImageView
  outlet :previewLabel, UILabel
  outlet :lengthLabel, UILabel
  outlet :minutesTextField, UITextField
  outlet :secondsTextField, UITextField
  outlet :countdownLengthView, UIView

  outlet :countdownLengthViewVerticalConstraint, NSLayoutConstraint

  attr_accessor :outputVC

  def viewDidLoad

    @countdown = CountdownTimer.sharedClient
    @appearance = Appearance.sharedClient

    @countdownMinutes = 5
    @countdownSeconds = 0

    updateCountdownLength

    @minutesTextField.text = @countdownMinutes.to_s
    @minutesTextField.delegate = self
    # @minutesTextField.inputAccessoryView = @countdownLengthView

    @secondsTextField.text = @countdownSeconds.to_s
    @secondsTextField.delegate = self
    # @secondsTextField.inputAccessoryView = @countdownLengthView

    # if UIScreen.mainScreen.bounds.size.height < 568
    #   @countdownLengthViewVerticalConstraint.constant = -@countdownLengthView.frame.size.height
    # end

  end

  def preferredStatusBarStyle

    UIStatusBarStyleLightContent
  
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

  end

  def updateCountdownLength

    length = @countdownMinutes.minutes + @countdownSeconds
    @countdown.setTime(length)

    UIApplication.sharedApplication.delegate.countdownHasChanged
    updateLengthLabel

  end

  def updateLengthLabel

    @lengthLabel.text = "#{@countdownMinutes.to_s} minutes"
    @lengthLabel.text += ", #{@countdownSeconds.to_s} seconds" unless @countdownSeconds == 0

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
    updateLengthLabel   # update length label but not countdown length to prevent change from effecting active countdown
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