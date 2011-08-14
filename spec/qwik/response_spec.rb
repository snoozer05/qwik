require File.join(File.dirname(__FILE__), "..", "spec_helper")

module Qwik
  describe Response do
    let(:mimetypes) { Hash.new }
    let(:response) { Qwik::Response.new(nil) }

    describe "#make_mimetypes" do
      describe "with argument {}" do
        before do
          response.make_mimetypes(mimetypes)
        end

        it "mimetypes['swf'] should == 'application/x-shockwave-flash'" do
          mimetypes['swf'].should == 'application/x-shockwave-flash'
        end

        it "mimetypes['smil'] should == 'application/smil'" do
          mimetypes['smil'].should == 'application/smil'
        end

        it "mimetypes['ico'] should == 'image/vnd.microsoft.icon'" do
          mimetypes['ico'].should == 'image/vnd.microsoft.icon'
        end

        it "mimetypes['png'] should == 'image/png'" do
          mimetypes['png'].should == 'image/png'
        end

        it "mimetypes['3gp'] should == 'video/3gpp'" do
          mimetypes['3gp'].should == 'video/3gpp'
        end
      end
    end

    describe "#[]" do
      describe "with index 'X-Test-Header'" do
        subject { response['X-Test-Header'] }
        it { should be_nil }

        context "when setting 't1' to 'X-Test-Header'" do
          before do
            response['X-Test-Header'] = 't1'
          end
          it { should == 't1' }

          context "when clearing response data" do
            before do
              response.clear
            end
            it { should be_nil }
          end
        end
      end
    end

    describe "#cookies" do
      subject { response.cookies }
      it { should have(0).items }

      context "when setting 2 items to Cookie" do
        before do
          response.set_cookies('t@e.com', 'testpass')
        end
        it { should have(2).items }

        context "when clearing response data" do
          before do
            response.clear
          end
          it { should have(0).items }
        end
      end
    end

    describe "#setback_body" do
      describe "with argument []" do
        subject { response.setback_body([]) }
        it { should == '' }
      end
      describe "with argument [:t, '']" do
        subject { response.setback_body([:t, ""]) }
        it { should == "<t\n></t\n>" }
      end
      describe "with argument 't'" do
        subject { response.setback_body('t') }
        it { should == 't' }
      end
      describe "with argument nil" do
        subject { response.setback_body(nil) }
        it { should == '' }
      end
    end

    context "when making mimetypes with WEBrick::HTTPUtils::DefaultMimeTypes " do
      before do
        response.make_mimetypes(WEBrick::HTTPUtils::DefaultMimeTypes)
      end

      describe "#get_mimetypes" do
        describe "with argument 'html'" do
          subject { response.get_mimetypes('html') }
          it { should == "text/html" }
        end
        describe "with argument 'txt'" do
          subject { response.get_mimetypes('txt') }
          it { should == "text/plain" }
        end
        describe "with argument 'css'" do
          subject { response.get_mimetypes('css') }
          it { should == "text/css" }
        end
        describe "with argument 'gif'" do
          subject { response.get_mimetypes('gif') }
          it { should == "image/gif" }
        end
        describe "with argument 'png'" do
          subject { response.get_mimetypes('png') }
          it { should == "image/png" }
        end
        describe "with argument 'jpg'" do
          subject { response.get_mimetypes('jpg') }
          it { should == "image/jpeg" }
        end
        describe "with argument 'JPG'" do
          subject { response.get_mimetypes('JPG') }
          it { should == "image/jpeg" }
        end
        describe "with argument 'JPEG'" do
          subject { response.get_mimetypes('JPEG') }
          it { should == "image/jpeg" }
        end
        describe "with argument 'smil'" do
          subject { response.get_mimetypes('smil') }
          it { should == "application/smil" }
        end
        describe "with argument 'zip'" do
          subject { response.get_mimetypes('zip') }
          it { should == "application/zip" }
        end
        describe "with argument 'mdlb'" do
          subject { response.get_mimetypes('mdlb') }
          it { should == "application/x-modulobe" }
        end
      end
    end
  end
end

