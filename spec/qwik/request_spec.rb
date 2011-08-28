require File.join(File.dirname(__FILE__), "..", "spec_helper")

module Qwik
  describe Request do
    let(:config) { Qwik::Config.new }
    let(:request) { Qwik::Request.new(config) }

    before do
      $test = false
    end

    describe "#start_time" do
      subject { request.start_time }
      it { should be_a_kind_of(Time) }
    end

    describe "#[]" do
      describe "with index 'k'" do
        subject { request['k'] }

        context "when header['k'] is nil" do
          it { should be_nil }
        end

        context "when header['k'] is empty" do
          before do
             request.instance_eval{ @header['k'] = [] }
          end
          it { should be_nil }
        end

        context "when header['k'] is ['v']" do
          before do
             request.instance_eval{ @header['k'] = ['v'] }
          end
          it { should == 'v' }
        end

        context "when heder['k'] is ['v1', 'v2']" do
          before do
            request.instance_eval{ @header['k'] = ['v1', 'v2'] }
          end
          it { should == 'v1, v2' }
        end
      end
    end

    describe "#is_post?" do
      subject { request.is_post? }

      context "when request method is nil" do
        it { should be_false }
      end

      context "when request method is GET" do
        before do
          request.instance_eval{ @request_method = "GET" }
        end

        it { should be_false }
      end

      context "when request method is POST" do
        before do
          request.instance_eval{ @request_method = "POST" }
        end

        it { should be_true }
      end
    end
  end
end

