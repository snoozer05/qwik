require File.join(File.dirname(__FILE__), "..", "spec_helper")

module Qwik
  shared_examples_for "a site with group" do
    describe "#inactive?" do
      describe "with argument Time.at(0)" do
        subject { site.inactive?(Time.at(0)) }
        it { should be_true }

        context "when create a new page with time 0" do
          before do
            site.create_new.put_with_time('a', 0)
          end
          it { should be_false }
        end

        context "when set GroupConfig to forward mode" do
          before do
            site.create('_GroupConfig').put_with_time(':forward:true', 0)  # forward mode.
          end
          it { should be_false }
        end
      end

      describe "with argument Time.at(0 + Qwik::Site::ML_LIFE_TIME_ALLOWANCE)" do
        subject { site.inactive?(Time.at(0 + Qwik::Site::ML_LIFE_TIME_ALLOWANCE)) }
        context "when change the life time to 0" do
          before do
            site['_SiteConfig'].put_with_time(':ml_life_time:0', 0)  # Die soon.
          end
          it { should be_true }
        end
      end
    end
  end

  describe Site, "deals with site group" do
    describe "site" do
      let(:site) { @site }
      it_behaves_like "a site with group"
    end

    describe "top_site" do
      let(:site) { @memory.farm.get_top_site }
      it_behaves_like "a site with group"
    end
  end
end
