require File.join(File.dirname(__FILE__), "..", "spec_helper")

module Qwik
  describe Server do
    let(:server) { Qwik::Server.new(@config) }

    def setup_request(env)
      Qwik::Request.new(server[:QwikConfig]).tap {|req|
        wreq = Qwik::WEBrickRequest.new(server.config).tap {|r|
          r.request_uri = URI.parse('http://example.com/test/')
          r.peeraddr = [nil, nil, nil, '127.0.0.1']
          r.path = env[:path_info]
          r.request_method = env[:request_method] ? env[:request_method] : 'GET'
        }
        req.parse_webrick(wreq)
      }
    end

    def setup_response
      Qwik::Response.new(server[:QwikConfig]).tap {|res|
        wres = Qwik::WEBrickResponse.new(server.config).tap{|r| r.set_config }
        res.set_webrick(wres)
      }
    end

    def run_action(req, res)
      action = Qwik::Action.new.tap {|act|
        act.init(server[:QwikConfig], server.memory, req, res)
      }
      $KCODE='S'
      action.run
      $KCODE='U'
      res
    end

    def call(env)
      req = setup_request(env)
      res = setup_response
      run_action(req, res)
    end

    describe "GET /" do
      before do
        @response = call(:path_info => '/')
      end

      it "should respond 200 OK" do
        @response.status.should == 200
      end

      it "should respond with Content-Type 'text/html; charset=Shift_JIS'" do
        @response['Content-Type'].should == "text/html; charset=Shift_JIS"
      end
    end

    describe "GET /.theme/css/base.css" do
      before do
        @response = call(:path_info => '/.theme/css/base.css')
      end

      it "should respond 200 OK" do
        @response.status.should == 200
      end

      it "should respond with Content-Type 'text/css'" do
        @response['Content-Type'].should == "text/css"
      end
    end

    after do
      server.shutdown
    end
  end
end

