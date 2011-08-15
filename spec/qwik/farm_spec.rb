require File.join(File.dirname(__FILE__), "..", "spec_helper")

module Qwik
  describe Farm do
    let(:farm) { @memory.farm }
    let(:config) { @config }
    let(:site_dir) { @dir }
    let(:site) { farm.get_site('test') }

    def rm_site_dir(dir)
      dir.teardown
      dir.rmtree if dir.directory?
      dir.rmdir  if dir.directory?
    end

    subject { farm }
    its(:list) { should be_a_kind_of(Array) }

    describe "#make_site" do
      let(:dir) { config.sites_dir.path }

      before do
        farm.close_all
        rm_site_dir(site_dir)
        farm.make_site('test', Time.at(0))
      end

      subject { farm.get_site('test') }
      its(:sitename) { should == 'test' }
      its(:path) { should be_exist }

      describe "test/_QwikSite.txt" do
        it "should be exist" do
          (dir + 'test/_QwikSite.txt').path.should be_exist
        end

        it "contents should == '1970-01-01T09:00:00'" do
          (dir + 'test/_QwikSite.txt').path.read == "1970-01-01T09:00:00"
        end
      end

      context "when site has same name is exist" do
        subject { expect { farm.make_site('test') }.to }
        it { should raise_error }
      end
    end

    describe "#get_top_site" do
      subject { farm.get_top_site.sitename }
      it { should == config.default_sitename }
    end

    describe "#get_site" do
      subject { farm.get_site('test') }

      context "when site exists" do
        it { should_not be_nil }
      end

      context "when site has gone" do
        before do
          site['_SiteConfig'].put_with_time(':ml_life_time:0', 0)  # Die soon.
        end

        it { should_not be_nil }

        context "and execute sweep" do
          before do
            farm.sweep
          end

          it { should be_nil }
        end
      end
    end

    describe "#delete" do
      let(:site_path) { site.path }

      before do
        farm.send(:delete, site)
      end

      it "site path should not be exist" do
        site_path.should_not be_exist
      end
    end
  end
end
