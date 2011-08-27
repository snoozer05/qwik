require File.join(File.dirname(__FILE__), "..", "spec_helper")

module Qwik
  describe Site, "deals with site log" do
    let(:site) { @site }
    let(:sitelog) { @site.sitelog }

    describe "#log" do
      describe "with arguments 0,'user@e.com', 'save', and '1'" do
        before do
          site.log(0,'user@e.com', 'save', '1')
        end

        it "_SiteLog should include ',0,user@e.com,save,1'" do
          site['_SiteLog'].load.should be_include(",0,user@e.com,save,1")
        end

        it "_SiteChanged should include ',0,user@e.com,save,1'" do
          site['_SiteChanged'].load.should be_include(",0,user@e.com,save,1")
        end

        context "and #log" do
          context "with arguments 0,nil, 'save', and '2'" do
            before do
              site.log(0, nil, 'save', '2')
            end

            it "_SiteLog should include ',0,user@e.com,save,1'" do
              site['_SiteLog'].load.should be_include(",0,user@e.com,save,1")
            end

            it "_SiteLog should include ',0,,save,2'" do
              site['_SiteLog'].load.should be_include(",0,,save,2")
            end

            it "_SiteChanged should include ',0,user@e.com,save,1'" do
              site['_SiteChanged'].load.should be_include(",0,user@e.com,save,1")
            end

            it "_SiteChanged should include ',0,,save,2'" do
              site['_SiteChanged'].load.should be_include(",0,,save,2")
            end
          end
        end
      end
    end
  end
end
