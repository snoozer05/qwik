# Copyright (C) 2003-2009 Kouichirou Eto, All rights reserved.
# This is free software with ABSOLUTELY NO WARRANTY.
# You can redistribute it and/or modify it under the terms of the GNU GPL 2.

$LOAD_PATH.unshift '..' unless $LOAD_PATH.include? '..'

module Qwik
  class Action
    def status_get_date
      now = Time.now
      puts "* "+now.strftime("%Y-%m-%dT%H:%M:%S")
    end

    def status_get_memory
      ps = `ps auxww | grep -i ruby`
      str = ''
      ps.each_line {|line|
	user, pid, cpu, mem, vsz, rss, tty, stat, start, time, command =
	  line.split(nil, 11)
	next if /^sh/ =~ command
	next if /^grep/ =~ command
	next if /^ruby/ =~ command
	next if %r|^/bin/sh| =~ command
	next if time == "0:00"

	command = 'quickml-server' if /quickml-server/ =~ command
	command = 'qwikweb-server' if /qwikweb-server/ =~ command

	vsz = vsz.to_i / 1000
	rss = rss.to_i / 1000

	str << "#{vsz}MB	#{rss}MB	#{command}\n"
      }
      str
    end

    def status_get_objects
      ar = []
      ObjectSpace.each_object {|obj|
        ar << obj.class.name
      }

      hash = Hash.new(0)
      ar.each {|classname|
        hash[classname] += 1
      }

      ar2 = []
      hash.each {|k, v|
        ar2 << |k, v|
      }

      ar3 = ar2.sort
#      ar3 = ar2.sort {|a, b|
#        a[0] < b[0]
#      }

      str = ''
#      hash.each {|k, v|
      ar3.each {|k, v|
        str << "#{v}\t#{k}\n"
      }
      str
    end


    def act_status
      str = "status\n"
#      str << status_get_date
      str << status_get_memory
      str << status_get_objects
      return c_notice(_('Status')) {
	[[:h2, _('Status')],
	  [:pre, str]]
      }
    end
  end
end

if $0 == __FILE__
  require 'qwik/test-common'
  $test = true
end

if defined?($test) && $test
  class TestActStatus < Test::Unit::TestCase
    include TestSession

    def test_all
    end
  end
end