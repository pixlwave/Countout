class AppearanceController < UIViewController
  extend IB

  outlet :previewView, UIView
  outlet :previewImageView, UIImageView
  outlet :previewLabel, UILabel

  outlet :fontScaleSlider, UISlider

  outlet :colorBorder, UIView
  outlet :fontBackgroundControl, UISegmentedControl
  outlet :colorPickerBorder, UIView

  def viewDidLoad
    super

    @appearance = Appearance.sharedClient
    @previewLabel.text = "#{(CountdownTimer.sharedClient.length / 60).to_s}:#{(CountdownTimer.sharedClient.length % 60).to_s.rjust(2,'0')}"

    @fontScaleSlider.value = @appearance.fontScale

    @colorBorder.backgroundColor = UIColor.clearColor
    @colorBorder.layer.cornerRadius = 6.0
    @colorBorder.layer.masksToBounds = true
    @colorBorder.layer.borderWidth = 1.0
    @colorBorder.layer.borderColor = UIColor.lightGrayColor.CGColor

    @colorPickerBorder.backgroundColor = UIColor.clearColor
    @colorPickerBorder.layer.cornerRadius = 6.0
    @colorPickerBorder.layer.masksToBounds = true
    @colorPickerBorder.layer.borderWidth = 1.0
    @colorPickerBorder.layer.borderColor = UIColor.darkGrayColor.CGColor

    @colorPicker = STColorPicker.alloc.initWithFrame([[0, 0], @colorPickerBorder.frame.size])
    @colorPicker.setColorHasChanged(lambda { |colorPointer, location|
      @appearance.send("#{@pickColorOf}=", colorPointer.to_object)# = color
      updateAppearance
    })

    @colorPickerBorder.addSubview(@colorPicker)

    @pickColorOf = "textColor"

    updateAppearance

  end

  def done

    presentingViewController.dismissModalViewControllerAnimated(true)

  end

  def reset

    @appearance.reset
    @fontScaleSlider.value = @appearance.fontScale
    
    updateAppearance

  end

  def chooseBackground

    imagePicker = UIImagePickerController.alloc.init
    imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary
    imagePicker.delegate = self

    self.presentViewController(imagePicker, animated:true, completion:nil)

  end

  def clearBackground

    @appearance.backgroundImage = nil
    updateAppearance

    @fontBackgroundControl.setEnabled(true, forSegmentAtIndex: 1)

  end

  def fontScaleChanged

    @appearance.fontScale = @fontScaleSlider.value
    updateAppearance

  end

  def toggleBoldFont

    if @appearance.fontName == "AvenirNext-UltraLight"
      @appearance.fontName = "AvenirNext-DemiBold"
    else
      @appearance.fontName = "AvenirNext-UltraLight"
    end

    updateAppearance

  end

  def fontBackgroundToggle

    if @fontBackgroundControl.selectedSegmentIndex == 0
      @pickColorOf = "textColor"
    else
      @pickColorOf = "backgroundColor"
    end

  end

  def updateAppearance

    @previewView.backgroundColor = @appearance.backgroundColor
    @previewImageView.image = @appearance.backgroundImage
    @previewLabel.setFont(UIFont.fontWithName(@appearance.fontName, size:(@appearance.fontScale * @previewLabel.frame.size.width)))
    @previewLabel.textColor = @appearance.textColor

    presentingViewController.outputVC.updateAppearance if presentingViewController.outputVC

  end


  #### image picker deleagte methods ####

  def imagePickerController(picker, didFinishPickingMediaWithInfo:info)

    image = info[UIImagePickerControllerOriginalImage]

    @appearance.backgroundImage = image
    updateAppearance

    @fontBackgroundControl.selectedSegmentIndex = 0
    @fontBackgroundControl.setEnabled(false, forSegmentAtIndex: 1)
    fontBackgroundToggle
    
    self.dismissViewControllerAnimated(true, completion:nil)

  end

  def imagePickerControllerDidCancel(picker)

    self.dismissViewControllerAnimated(true, completion:nil)

  end

end