# -*- coding: utf-8 -*-
$:.unshift File.join("..", "lib", "qwik")

require 'qwik/test-module-suite'
require 'qwik/test-module-ml'
require 'pp'
require 'qwik/qp'
require 'qwik/testunit'
require 'qwik/test-module-session'
require 'qwik/server'

$test = false

Bundler.require :test if defined?(Bundler)
