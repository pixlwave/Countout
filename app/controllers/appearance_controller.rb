class AppearanceController < UIViewController
  extend IB

  outlet :previewView, UIView
  outlet :previewImageView, UIImageView
  outlet :previewLabel, UILabel

  outlet :fontScaleSlider, UISlider

  def viewDidLoad

    super

    @appearance = Appearance.sharedClient

    @fontScaleSlider.value = @appearance.fontScale

    updateAppearance

  end

  def done

    presentingViewController.dismissModalViewControllerAnimated(true)

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

  def updateAppearance

    @previewView.backgroundColor = @appearance.backgroundColor
    @previewImageView.image = @appearance.backgroundImage
    @previewLabel.setFont(UIFont.fontWithName(@appearance.fontName, size:(@appearance.fontScale * @previewLabel.frame.size.width)))
    @previewLabel.textColor = @appearance.textColor

    presentingViewController.outputVC.updateAppearance if presentingViewController.outputVC

  end


  #### image picker deleagte methods ####

  def imagePickerController(picker, didFinishPickingMediaWithInfo:info)

    # image = info.valueForKey(UIImagePickerControllerOriginalImage)
    image = info[UIImagePickerControllerOriginalImage]

    @appearance.backgroundImage = image
    updateAppearance

    self.dismissViewControllerAnimated(true, completion:nil)

  end

  def imagePickerControllerDidCancel(picker)

    self.dismissViewControllerAnimated(true, completion:nil)

  end

end