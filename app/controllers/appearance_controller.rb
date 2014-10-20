class AppearanceController < UIViewController
  extend IB

  outlet :previewView, UIView
  outlet :previewImageView, UIImageView
  outlet :previewLabel, UILabel

  outlet :borderView, UIView
  outlet :settingsView, UIView

  outlet :fontView, UIView
  outlet :fontScaleSlider, UISlider
  outlet :fontWeightButton, UIButton

  outlet :backgroundView, UIView

  outlet :fontBackgroundControl, UISegmentedControl
  outlet :colorPickerBorder, UIView

  def viewDidLoad
    super

    @appearance = Appearance.sharedClient
    @previewLabel.text = "#{(CountdownTimer.sharedClient.length / 60).to_s}:#{(CountdownTimer.sharedClient.length % 60).to_s.rjust(2,'0')}"

    @borderView.backgroundColor = UIColor.clearColor
    @borderView.layer.cornerRadius = 6.0
    @borderView.layer.masksToBounds = true
    @borderView.layer.borderWidth = 1.0
    @borderView.layer.borderColor = UIColor.lightGrayColor.CGColor

    NSBundle.mainBundle.loadNibNamed("FontAppearanceView", owner:self, options:nil)
    @fontScaleSlider.value = @appearance.fontScale
    @borderView.addSubview(@fontView)
    layoutView(@fontView, toMatchView: @settingsView)

    NSBundle.mainBundle.loadNibNamed("BackgroundAppearanceView", owner:self, options:nil)
    @backgroundView.alpha = 0
    @borderView.addSubview(@backgroundView)
    layoutView(@backgroundView, toMatchView: @settingsView)

    @colorPickerBorder.backgroundColor = UIColor.clearColor
    @colorPickerBorder.layer.cornerRadius = 6.0
    @colorPickerBorder.layer.masksToBounds = true
    @colorPickerBorder.layer.borderWidth = 1.0
    @colorPickerBorder.layer.borderColor = UIColor.darkGrayColor.CGColor

    @colorPicker = STColorPicker.alloc.initWithFrame(@colorPickerBorder.bounds)
    @colorPicker.setColorHasChanged(lambda { |colorPointer, location|
      @appearance.send("#{@pickColorOf}=", colorPointer.to_object)# = color
      updateAppearance
    })

    @colorPickerBorder.addSubview(@colorPicker)

    @pickColorOf = "textColor"

    updateAppearance

  end

  def layoutView(view1, toMatchView: view2)

    view1.translatesAutoresizingMaskIntoConstraints = false
    view1.superview.addConstraint(NSLayoutConstraint.constraintWithItem(view1, attribute: NSLayoutAttributeLeading, relatedBy: NSLayoutRelationEqual, toItem: view2, attribute: NSLayoutAttributeLeading, multiplier: 1, constant: 0))
    view1.superview.addConstraint(NSLayoutConstraint.constraintWithItem(view1, attribute: NSLayoutAttributeTrailing, relatedBy: NSLayoutRelationEqual, toItem: view2, attribute: NSLayoutAttributeTrailing, multiplier: 1, constant: 0))
    view1.superview.addConstraint(NSLayoutConstraint.constraintWithItem(view1, attribute: NSLayoutAttributeTop, relatedBy: NSLayoutRelationEqual, toItem: view2, attribute: NSLayoutAttributeTop, multiplier: 1, constant: 0))
    view1.superview.addConstraint(NSLayoutConstraint.constraintWithItem(view1, attribute: NSLayoutAttributeBottom, relatedBy: NSLayoutRelationEqual, toItem: view2, attribute: NSLayoutAttributeBottom, multiplier: 1, constant: 0))

  end

  def viewDidLayoutSubviews

    @colorPicker.frame = @colorPickerBorder.bounds

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

  end

  def fontScaleChanged

    @appearance.fontScale = @fontScaleSlider.value
    updateAppearance

  end

  def toggleBoldFont

    if @appearance.fontWeight == "UltraLight"
      @appearance.fontWeight = "DemiBold"
    else
      @appearance.fontWeight = "UltraLight"
    end

    updateAppearance

  end

  def fontBackgroundToggle

    if @fontBackgroundControl.selectedSegmentIndex == 0
      @pickColorOf = "textColor"
      @fontView.alpha = 1
      @backgroundView.alpha = 0
    else
      @pickColorOf = "backgroundColor"
      @fontView.alpha = 0
      @backgroundView.alpha = 1
    end

  end

  def updateAppearance

    @previewView.backgroundColor = @appearance.backgroundColor
    @previewImageView.image = @appearance.backgroundImage
    @previewLabel.setFont(UIFont.fontWithName(@appearance.fontName, size:(@appearance.fontScale * @previewLabel.frame.size.width)))
    @previewLabel.textColor = @appearance.textColor

    if @appearance.fontWeight == "UltraLight"
      @fontWeightButton.setTitle("Bold", forState: UIControlStateNormal)
    else
      @fontWeightButton.setTitle("Light", forState: UIControlStateNormal)
    end

    presentingViewController.updateAppearance if UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad
    presentingViewController.outputVC.updateAppearance if presentingViewController.outputVC

  end


  #### image picker deleagte methods ####

  def imagePickerController(picker, didFinishPickingMediaWithInfo:info)

    image = info[UIImagePickerControllerOriginalImage]

    @appearance.backgroundImage = image
    updateAppearance
    
    self.dismissViewControllerAnimated(true, completion:nil)

  end

  def imagePickerControllerDidCancel(picker)

    self.dismissViewControllerAnimated(true, completion:nil)

  end

end