# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Countout'
  app.icons = ['Icon@2x.png', 'Icon-iPad@2x']
  app.identifier = 'uk.pixlwave.Countout'
  app.device_family = [:iphone, :ipad]
  app.status_bar_style = :light_content
  app.interface_orientations = [:portrait, :landscape_left, :landscape_right, :portrait_upside_down]

  app.info_plist['UILaunchStoryboardName'] = 'LaunchScreen'

  app.development do
    app.provisioning_profile = '/Users/Douglas/Documents/RubyMotion/Certificates/Countoutdevelopment.mobileprovision'
  end

  app.pods do
    pod 'STColorPicker'
    # pod 'NKOColorPickerView'
  end
end
