class CountdownController < UIViewController
  extend IB

  attr_accessor :countdownMinutes, :countdownSeconds

  outlet :previewView, UIView
  outlet :previewImageView, UIImageView
  outlet :previewLabel, UILabel
  outlet :lengthLabel, UILabel
  outlet :countdownLengthView, UIView
  outlet :minutesTextField, UITextField
  outlet :secondsTextField, UITextField

  outlet :countdownLengthViewVerticalConstraint, NSLayoutConstraint

  attr_accessor :outputVC

  def viewDidLoad

    @countdown = CountdownTimer.sharedClient
    @appearance = Appearance.sharedClient

    @countdownMinutes = 5
    @countdownSeconds = 0

    updateLengthLabel

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

  def viewWillAppear(animated)

    @previewImageView.image = @appearance.backgroundImage

  end

  def updateLengthLabel

    @lengthLabel.text = "#{@countdownMinutes.to_s} minutes"
    @lengthLabel.text += ", #{@countdownSeconds.to_s} seconds" unless @countdownSeconds == 0

  end

  def start

    length = @countdownMinutes.minutes + @countdownSeconds

    @countdown.setTime(length)
    UIApplication.sharedApplication.delegate.countdownHasChanged
    @countdown.start

  end

  def stop

    @countdown.stop

  end

  def editCountdownLength

    @countdownLengthView.fade_in
    @minutesTextField.becomeFirstResponder

  end

  def finishCountdownLength

    self.view.endEditing(true)
    @countdownMinutes = @minutesTextField.text.to_i
    @countdownSeconds = @secondsTextField.text.to_i
    updateLengthLabel
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