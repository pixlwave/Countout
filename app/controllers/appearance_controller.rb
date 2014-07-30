class AppearanceController < UIViewController
  extend IB

  outlet :previewView, UIView
  outlet :previewImageView, UIImageView
  outlet :previewLabel, UILabel

  def viewDidLoad

    super

    @appearance = Appearance.sharedClient

    @previewImageView.image = @appearance.backgroundImage
    @previewLabel.setFont(UIFont.fontWithName("AvenirNext-UltraLight", size:(@appearance.fontScale * @previewLabel.frame.size.width)))

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

  def updateAppearance

    @previewImageView.image = @appearance.backgroundImage

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