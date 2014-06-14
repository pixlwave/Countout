class AppDelegate
  
  def application(application, didFinishLaunchingWithOptions:launchOptions)

    application.setIdleTimerDisabled(true)

    # application.setStatusBarStyle(UIStatusBarStyleLightContent, animated:false)

    @countdown = CountdownTimer.sharedClient
    @countdown.delegate = self

    if UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone
      @storyboard = UIStoryboard.storyboardWithName("Storyboard", bundle:nil)
    else
      @storyboard = UIStoryboard.storyboardWithName("Storyboard-iPad", bundle:nil)
    end

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = @storyboard.instantiateInitialViewController
    @window.makeKeyAndVisible

    updateOutput

    NSNotificationCenter.defaultCenter.addObserver(self, selector:"updateOutput", name:UIScreenDidConnectNotification, object:nil)
    NSNotificationCenter.defaultCenter.addObserver(self, selector:"updateOutput", name:UIScreenDidDisconnectNotification, object:nil)
  
    true
  
  end

  def updateOutput

    if UIScreen.screens.count > 1

      @externalWindow = UIWindow.alloc.initWithFrame(UIScreen.screens[1].bounds)
      @externalWindow.screen = UIScreen.screens[1]

      @outputVC = @storyboard.instantiateViewControllerWithIdentifier("Output")

      @externalWindow.rootViewController = @outputVC
      @externalWindow.hidden = false

      @window.rootViewController.outputVC = @outputVC
      @window.rootViewController.outputStatusLabel.fade_out

      countdownHasChanged

    else

      @window.rootViewController.outputVC = nil
      @outputVC = nil
      @externalWindow = nil

      @window.rootViewController.outputStatusLabel.fade_in

    end

  end

  def countdownHasChanged

    remainingString = "#{(@countdown.remaining / 60).to_s}:#{(@countdown.remaining % 60).to_s.rjust(2,'0')}"
    @outputVC.timeLabel.text = remainingString if @outputVC
    @window.rootViewController.previewLabel.text = remainingString

  end

  def applicationDidEnterBackground(application)

    @backgroundTime = NSDate.now if @countdown.active?

  end

  def applicationDidBecomeActive(application)

    if @backgroundTime

      timePassed = (NSDate.now - @backgroundTime).to_i
      @countdown.addToRemaining(-timePassed)

      @backgroundTime = nil

    end

  end

end