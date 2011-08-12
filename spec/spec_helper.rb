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

RSpec.configure do |spec_config|
  spec_config.before(:each) do
    @config = Qwik::Config.new.tap{ |c|
      c[:logger] = QuickML::MockLogger.new
      c.update(Qwik::Config::DebugConfig)
      c.update(Qwik::Config::TestConfig)
      QuickML::ServerMemory.init_mutex(c)
      QuickML::ServerMemory.init_catalog(c)

      c.sites_dir.path.check_directory
      c.grave_dir.path.check_directory
      c.cache_dir.path.check_directory
      c.etc_dir.path.check_directory
      c.log_dir.path.check_directory
    }

    @org_sites_dir = @config[:sites_dir].dup

    @memory = Qwik::ServerMemory.new(@config).tap{|m|
      logfile = '.test/testlog.txt'
      loglevel = WEBrick::Log::INFO
      logger = WEBrick::Log::new(logfile, loglevel)
      m[:logger] = logger

      burylogfile = '.test/testburylog.txt'
      log = ::Logger.new(burylogfile)
      log.level = ::Logger::INFO
      m[:bury_log] = log
    }

    # setup dir
    @wwwdir = @config.sites_dir.path + 'www'
    @wwwdir.setup

    @dir = @config.sites_dir.path + 'test'
    @dir.setup

    # setup site
    @site = @memory.farm.get_site('test')
  end

  spec_config.after(:each) do
    @site.erase_all if defined?(@site) && @site
    @wwwdir.teardown if @wwwdir
    @dir.teardown if @dir
  end
end
