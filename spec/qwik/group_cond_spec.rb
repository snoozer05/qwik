require File.join(File.dirname(__FILE__), "..", "spec_helper")
require 'qwik/group'

module QuickML
  describe Group, "deals with group conditions" do
    let(:group) { QuickML::Group.new(@config, 'test@example.com') }

    describe ".load_count" do
      context "when target db's count is 1" do
        let(:db) {
          QuickML::GroupDB.new('./.test/data', 'test').tap{|db|
            stub(db).exist?(:Count) { true }
            stub(db).get(:Count) { "1" }
          }
        }

        subject { QuickML::Group.load_count(db) }
        it { should == 1 }
      end

      context "when target db's count is 12" do
        let(:db) {
          QuickML::GroupDB.new('./.test/data', 'test').tap{|db|
            stub(db).exist?(:Count) { true }
            stub(db).get(:Count) { "12" }
          }
        }

        subject { QuickML::Group.load_count(db) }
        it { should == 12 }
      end
    end

    describe ".parse_charset" do
      subject { QuickML::Group }

      describe "with argument ''" do
        subject { QuickML::Group.parse_charset('') }
        it { should == '' }
      end

      describe "with argument 't\\n'" do
        subject { QuickML::Group.parse_charset("t\n") }
        it { should == 't' }
      end

      describe "with argument 't\\ns\\n'" do
        subject { QuickML::Group.parse_charset("t\ns\n") }
        it { should == 't' }
      end

      describe "with argument 'iso-2022-jp\\n'" do
        subject { QuickML::Group.parse_charset("iso-2022-jp\n") }
        it { should == 'iso-2022-jp' }
      end
    end

    describe "#newly_created?" do
      subject { group }

      context "when group doesn't have member" do
        it { should be_newly_created }
      end

      context "when group has member" do
        before do
          group.add_member('user@e.com')
        end

        it { should_not be_newly_created }
      end
    end

    describe "#count" do
      before do
        group.send(:init_count)
      end

      subject { group.send(:count) }

      context "when newly created" do
        it { should be_zero }
      end

      context "when count was incremented" do
        before do
          group.send(:inc_count)
        end

        it { should == 1 }
      end
    end

    describe "#charset" do
      subject { group.charset }
      it { should be_nil }

      context "when init charset 'iso-2022-jp'" do
        before do
          group.send(:save_charset, 'iso-2022-jp')
          group.send(:init_charset)
        end

        it { should == "iso-2022-jp" }
      end
    end

    describe "#save_charset" do
      describe "with argument 'iso-2022-jp'" do
        before do
          group.send(:save_charset, 'iso-2022-jp')
        end

        it "group db's charset should be iso-2022-jp" do
          group.instance_eval{ @db }.get(:Charset).should == "iso-2022-jp\n"
        end
      end
    end

    describe "#alerted?" do
      subject { group }

      it { should_not be_alerted }

      context "close_alertedp_file" do
        before do
          group.send(:close_alertedp_file)
        end

        it { should be_alerted }

        context "remove_alertedp_file" do
          before do
            group.send(:remove_alertedp_file)
          end

          it { should_not be_alerted }
        end
      end
    end
  end
end
