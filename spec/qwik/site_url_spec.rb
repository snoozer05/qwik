require File.join(File.dirname(__FILE__), "..", "spec_helper")

module Qwik
  describe Site, "deals with site url" do
    let(:config) { @config }
    let(:site) { @site }
    let(:top_site) { @memory.farm.get_top_site }
    let(:siteconfig) { site.create('_SiteConfig') }

    before do
      config[:test]  = false
      config[:debug] = false
    end

    subject { site }

    describe "#host_url" do
      subject { site.host_url }
      it { should == 'http://example.com' }

      context "when setting ':siteurl:http://example.org/q/' to _SiteConfig" do
        before do
          siteconfig.store(":siteurl:http://example.org/q/\n")
        end
        it { should == 'http://example.org' }
      end

      context "when public_url is http://example.org/q/" do
        before do
          config[:public_url] = "http://example.org/q/"
        end
        it { should == 'http://example.org' }
      end
    end

    describe "#ml_address" do
      subject { site.ml_address }
      it { should == 'test@q.example.com' }

      context "when setting ':siteml:info@example.org' to _SiteConfig" do
        before do
          siteconfig.store(":siteml:info@example.org\n")
        end
        it { should == 'info@example.org' }
      end
    end

    describe "#site_url" do
      subject { site.site_url }
      context "when site is top site" do
        let(:site) { top_site }
        it { should == "http://example.com/" }
      end

      context "when site is not top site" do
        it { should == "http://example.com/test/" }
      end

      context "when setting ':siteurl:http://example.org/q/' to _SiteConfig" do
        before do
          siteconfig.store(":siteurl:http://example.org/q/\n")
        end
        it { should == 'http://example.org/q/' }
      end

      context "when public_url is http://example.org/q/" do
        before do
          config[:public_url] = "http://example.org/q/"
        end
        it { should == 'http://example.org/q/test/' }
      end
    end

    describe "#top_site?" do
      subject { site.top_site? }
      context "when site is top site" do
        let(:site) { top_site }
        it { should be_true }
      end

      context "when site is not top site" do
        it { should be_false }
      end
    end

    describe "#title" do
      subject { site.title }
      it { should == 'example.com/test' }

      context "when setting ':sitename:t' to _SiteConfig" do
        before do
          siteconfig.store(":sitename:t\n")
        end
        it { should == 't' }
      end
    end

    describe "#page_url" do
      describe "with argument '1'" do
        subject { site.page_url('1') }
        it { should == 'http://example.com/test/1.html' }
 
        context "when site is top site" do
          let(:site) { top_site }
          it { should == 'http://example.com/1.html' }
        end

        context "when setting ':siteurl:http://example.org/q/' to _SiteConfig" do
          before do
            siteconfig.store(":siteurl:http://example.org/q/\n")
          end
          it { should == 'http://example.org/q/1.html' }
        end

        context "when public_url is http://example.org/q/" do
          before do
            config[:public_url] = "http://example.org/q/"
          end
          it { should == 'http://example.org/q/test/1.html' }
        end

      end
    end

    describe "#get_page_title" do
      describe "with argument '1'" do
        before do
          site.create_new
        end

        subject { site.get_page_title('1') }
        it { should == '1 - example.com/test' }

        context "when site is top site" do
          let(:site) { top_site }
          it { should == '1 - example.com' }
        end

        context "when setting ':sitename:t' to _SiteConfig" do
          before do
            siteconfig.store(":sitename:t\n")
          end
          it { should == '1 - t' }
        end

        context "when setting ':page_title_first:true' to _SiteConfig" do
          before do
            siteconfig.store(":page_title_first:true\n")
          end
          it { should == '1 - example.com/test' }
        end

        context "when setting ':page_title_first:false' to _SiteConfig" do
          before do
            siteconfig.store(":page_title_first:false\n")
          end
          it { should == 'example.com/test - 1' }
        end
      end
    end
  end
end
