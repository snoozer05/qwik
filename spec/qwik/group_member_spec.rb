require File.join(File.dirname(__FILE__), "..", "spec_helper")
require 'qwik/group'

module QuickML
  describe Group, "deals with group members" do
    let(:group) { QuickML::Group.new(@config, 'test@example.com') }

    describe ".exclude?" do
      describe "with arguments 'user' and 'example.net'" do
        subject { QuickML::Group.exclude?('user', 'example.net') }
        it { should be_true }
      end

      describe "with arguments 'user@example.net' and 'example.net'" do
        subject { QuickML::Group.exclude?('user@example.net', 'example.net') }
        it { should be_true }
      end

      describe "with arguments 'user@example.com' and 'example.net'" do
        subject { QuickML::Group.exclude?('user@example.com', 'example.net') }
        it { should be_false }
      end
    end

    context "#active_members_include?" do
      describe "with argument 'user@e.com'" do
        context "and 'user@e.com' is a avtive member" do
          before do
            group.add_member('user@e.com')
          end

          subject { group.active_members_include?('user@e.com') }
          it { should be_true }
        end

        context "and 'user@e.com' is not a avtive member" do
          before do
            group.add_member('user@e.com')
            group.add_member('user2@e.com')
            group.remove_member('user@e.com')
          end

          subject { group.active_members_include?('user@e.com') }
          it { should be_false }
        end
      end
    end

    context "#former_members_include?" do
      describe "with argument 'user@e.com'" do
        context "and 'user@e.com' is a former member" do
          before do
            group.add_member('user@e.com')
            group.add_member('user2@e.com')
            group.remove_member('user@e.com')
          end

          subject { group.former_members_include?('user@e.com') }
          it { should be_true }
        end

        context "and 'user@e.com' is not a former member" do
          before do
            group.add_member('user@e.com')
          end

          subject { group.former_members_include?('user@e.com') }
          it { should be_false }
        end
      end
    end
  end

  describe GroupMembers do
    let(:group) { QuickML::Group.new(@config, 'test@example.com') }

    context "when called Group#add_member" do
      context "once" do
        before do
          group.add_member('user@e.com')
        end

        subject { group.instance_eval{ @db }.get(:Members) }
        it { should == "user@e.com\n" }
      end

      context "twice" do
        before do
          group.add_member('user@e.com')
          group.add_member('user2@e.com')
        end

        subject { group.instance_eval{ @db }.get(:Members) }
        it { should == "user@e.com\nuser2@e.com\n" }
      end
    end

    context "when called Group#add_error_member" do
      describe "with argument 'user@e.com' and user@e.com is a member" do
        before do
          group.add_member('user@e.com')
          group.add_error_member('user@e.com')
        end

        subject { group.instance_eval{ @db }.get(:Members) }
        it { should be_include "user@e.com 1" }
      end
    end

    context "when called Group#remove_member" do
      describe "with argument 'user@e.com'" do
        context "and group has only 'user@e.com' member" do
          before do
            group.add_member('user@e.com')
            group.remove_member('user@e.com')
          end

          subject { group.instance_eval{ @db }.get(:Members) }
          it { should be_nil }
        end

        context "and group has several member" do
          before do
            group.add_member('user@e.com')
            group.add_member('user2@e.com')
            group.remove_member('user@e.com')
          end

          subject { group.instance_eval{ @db }.get(:Members) }
          it { should be_include "# user@e.com\n" }
        end
      end
    end
  end
end
