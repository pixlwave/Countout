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
  app.version = '1.0'
  app.identifier = 'uk.pixlwave.Countout'
  app.device_family = [:iphone]
  app.status_bar_style = :light_content
  app.deployment_target = "8.0"
  app.interface_orientations = [:portrait, :portrait_upside_down]
  # app.interface_orientations = [:portrait, :landscape_left, :landscape_right, :portrait_upside_down]

  app.info_plist['UILaunchStoryboardName'] = 'LaunchScreen'

  app.vendor_project('vendor/STColorPicker', :static, :cflags => '-fobjc-arc')
  app.resources_dirs << 'vendor/STColorPicker/resources'

  app.development do
    app.provisioning_profile = '/Users/Douglas/Documents/RubyMotion/Certificates/Countout_development.mobileprovision'
  end

  app.release do
    app.provisioning_profile = '/Users/Douglas/Documents/RubyMotion/Certificates/Countout.mobileprovision'
  end

end
