require File.join(File.dirname(__FILE__), "..", "spec_helper")
require 'qwik/group'

module QuickML
  describe Group, "deals with group sweep" do
    let(:group) { QuickML::Group.new(@config, 'test@example.com') }

    context "newly created" do
      subject { group }
      it { should_not be_alerted }
      it { should_not be_need_alert(Time.at(0)) }
      it { should_not be_need_alert(Time.at(1000000000)) }

      describe "#group_config" do
        describe "with argument :ml_life_time" do
          subject { group.instance_eval{ @group_config[:ml_life_time] }}
          it { should == 2678400 }
        end
      end
    end
  end
end
