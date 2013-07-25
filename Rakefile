# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

require 'bundler/setup'
Bundler.require :default

require 'bubble-wrap/rss_parser'

Motion::Project::App.setup do |app|
  app.name = 'YonaClient'

  app.pods do
    pod 'Reachability', '~>3.0.0'
    pod 'SSPullToRefresh'
  end
end
