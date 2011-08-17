require File.join(File.dirname(__FILE__), "..", "spec_helper")

module Qwik
  describe SiteMember do
    let(:site) { @site }
    let(:member) { site.member }
    let(:sitemember_page) { site.create('_SiteMember') }

    describe "#exist?" do
      describe "with argument 'user@e.com'" do
        subject { member.exist?('user@e.com') }

        before do
          sitemember_page
        end
        it { should be_false }

        context "after #add with 'user@e.com'" do
          before do
            sitemember_page
            member.add('user@e.com')
          end
          it { should be_true }

          context "and delete _SiteMember" do
            before do
              site.delete('_SiteMember')
            end
            it { should be_false }
          end
        end

        context "when _SiteMember contains ',user@e.com'" do
          before do
            sitemember_page.store(',user@e.com')
          end
          it { should be_true }
        end

        context "when _SiteMember contains ',user@e.com,'" do
          before do
            sitemember_page.store(',user@e.com,')
          end
          it { should be_true }
        end

        context "when _SiteMember contains ',user@e.com,a'" do
          before do
            sitemember_page.store(',user@e.com,a')
          end
          it { should be_true }
        end

        context "when _SiteMember contains ',user@e.com,a,'" do
          before do
            sitemember_page.store(',user@e.com,a,')
          end
          it { should be_true }
        end
      end
    end

    describe "#add" do
      describe "with argument 'user@e.com'" do
        before do
          sitemember_page
          member.add('user@e.com')
        end

        it "should add that acount from site member" do
          member.exist?('user@e.com').should be_true
        end

        it "should add that acount from SiteMember" do
          sitemember_page.load.should == ",user@e.com,\n"
        end
      end

      describe "with arguments 'guest@example.com' and 'user@e.com' " do
        before do
          sitemember_page
          member.add('guest@example.com', 'user@e.com')
        end

        it "should add that acount from site member" do
          member.exist?('guest@example.com').should be_true
        end

        it "should add that acount from SiteMember" do
          sitemember_page.load.should == ",guest@example.com,user@e.com\n"
        end
      end
    end

    describe "#remove" do
      describe "with argument 'user@e.com'" do
        before do
          sitemember_page.store(',user@e.com')
          member.remove('user@e.com')
        end

        it "should remove that acount from site member" do
          member.exist?('user@e.com').should be_false
        end

        it "should remove that acount from SiteMember" do
          sitemember_page.load.should == ''
        end
      end
    end
  end

  describe QuickMLMember do
    let(:site) { @site }
    let(:member) { site.member }
    let(:sitemember_page) { site.create('_SiteMember') }

    def store(content) # quickml_member
      (@dir+'_GroupMembers.txt').put(content)
    end

    describe "#exist?" do
      describe "with argument 'user@e.com'" do
        subject { member.exist?('user@e.com') }

        before do
          sitemember_page
        end
        it { should be_false }

        context "after add 'user@e.com' to _GroupMembers" do
          before do
            store('user@e.com')
          end
          it { should be_true }

          context "and update '# user@e.com' _SiteMember" do
            before do
              store('# user@e.com')
            end
            it { should be_false }
          end

          context "and update '; user@e.com' _SiteMember" do
            before do
              store('# user@e.com')
            end
            it { should be_false }
          end
        end
      end
    end
  end
end
