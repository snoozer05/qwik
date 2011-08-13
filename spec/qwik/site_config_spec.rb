require File.join(File.dirname(__FILE__), "..", "spec_helper")

module Qwik
  describe Site, "deals with site config" do
    let(:site) { @site }
    let(:config_page) { site.create '_SiteConfig' }

    describe "#is_open?" do
      subject { site.is_open? }
      context "_SiteConfig isn't exist" do
        it { should be_false }
      end

      context "_SiteConfig is exist" do
        before do
          site.create '_SiteConfig'
        end

        context "and contains ':open:true'" do
          before do
            config_page.store ':open:true'
          end

          it { should be_true }
        end

        context "and contains ':open:false'" do
          before do
            config_page.store ':open:false'
          end

          it { should be_false }
        end
      end
    end

    describe "#siteconfig" do
      describe "with argument 'sitename'" do
        subject { site.siteconfig['sitename'] }
        it { should == "" }

        context "stored ':sitename:TestSite' to SiteConfig" do
          before do
            config_page.store ':sitename:TestSite'
          end

          it { should == "TestSite" }
        end
      end

      describe "with argument 'open'" do
        subject { site.siteconfig['open'] }
        it { should == "false" }

        context "added ':open:true' to _SiteConfig" do
          before do
            config_page.store ':open:true'
          end

          it { should == "true" }
        end
      end

      describe "with argument 'max_file_size'" do
        subject { site.siteconfig['max_file_size'] }
        it { should == "10485760" }
      end
    end

    describe "#title" do
      subject { site.title }
      it { should == "" }

      context "stored ':sitename:TestSite' to SiteConfig" do
        before do
          config_page.store ':sitename:TestSite'
        end

        it { should == "TestSite" }
      end
    end

    describe "#is_blessed?" do
      subject { site.is_blessed? }
      it { should be_false }

      context "blessed" do
        before do
          (site.path + ",blessed").write("")
        end

        it { should be_true }
      end
    end
  end
end
