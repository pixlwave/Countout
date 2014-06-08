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
  app.name = 'Countdown'
  app.icons = ["Icon@2x.png"]
  app.identifier = 'uk.pixlwave.Countdown'
  app.device_family = [:iphone, :ipad]
  app.status_bar_style = :light_content
  app.interface_orientations = [:portrait, :landscape_left, :landscape_right, :portrait_upside_down]
end
