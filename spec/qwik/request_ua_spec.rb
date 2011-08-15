require File.join(File.dirname(__FILE__), "..", "spec_helper")

module Qwik
  describe UserAgent do
    let(:request) { Qwik::Request.new(nil) }
    let(:ua) { Qwik::UserAgent.new(request) }

    describe ".parse" do
      describe "with argument {'user-agent'=>'DoCoMo/1.0/N504i/c10/TB'}" do
        subject { Qwik::UserAgent.parse({'user-agent' => 'DoCoMo/1.0/N504i/c10/TB'}) }
        it { should == ['docomo', nil] }
      end

      describe "with argument {'user-agent'=>'DoCoMo/1.0/N504i/c10/TB/serNMAIA000001'}" do
        subject { Qwik::UserAgent.parse({'user-agent' => 'DoCoMo/1.0/N504i/c10/TB/serNMAIA000001'}) }
        it { should == ['docomo', 'NMAIA000001'] }
      end

      describe "with argument {'user-agent'=>'KDDI-TS23 UP.Browser/6.0.7.2 (GUI) MMP/1.1'}" do
        subject { Qwik::UserAgent.parse({'user-agent' => "KDDI-TS23 UP.Browser/6.0.7.2 (GUI) MMP/1.1"}) }
        it { should == ['ezweb', nil] }
      end

      describe "with argument {'user-agent'=>'KDDI-TS23 UP.Browser/6.0.7.2 (GUI) MMP/1.1', 'x-up-subno'=>'XXXXXXXXXXXXXXXXX.ezweb.ne.jp'}" do
        subject { Qwik::UserAgent.parse({'user-agent' => 'KDDI-TS23 UP.Browser/6.0.7.2 (GUI) MMP/1.1', 'x-up-subno'=>'XXXXXXXXXXXXXXXXX.ezweb.ne.jp'}) }
        it { should == ['ezweb', 'XXXXXXXXXXXXXXXXX.ezweb.ne.jp'] }
      end
    end

    describe "#mobile" do
      subject { ua.mobile }
      it { should be_nil }

      context "when user-agent is 'DoCoMo/1.0/N504i/c10/TB'" do
        before do
          request.instance_eval{ @header['user-agent'] = ['DoCoMo/1.0/N504i/c10/TB'] }
        end
        it { should == 'docomo' }
      end

      context "when user-agent is 'KDDI-TS23 UP.Browser/6.0.7.2 (GUI) MMP/1.1'" do
        before do
          request.instance_eval{ @header['user-agent'] = ['KDDI-TS23 UP.Browser/6.0.7.2 (GUI) MMP/1.1'] }
        end
        it { should == 'ezweb' }
      end
    end

    describe "#serial" do
      subject { ua.serial }
      it { should be_nil }

      context "when user-agent is 'DoCoMo/1.0/N504i/c10/TB'" do
        before do
          request.instance_eval{ @header['user-agent'] = ['DoCoMo/1.0/N504i/c10/TB'] }
        end
        it { should be_nil }
      end

      context "when user-agent is 'DoCoMo/1.0/N504i/c10/TB/serNMAIA000001'" do
        before do
          request.instance_eval{ @header['user-agent'] = ['DoCoMo/1.0/N504i/c10/TB/serNMAIA000001'] }
        end
        it { should == 'NMAIA000001' }
      end
    end
  end
end
