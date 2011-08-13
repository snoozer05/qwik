require File.join(File.dirname(__FILE__), "..", "spec_helper")

module Qwik
  describe Page do
    subject { @site.get_pages.create_new }
    its(:url) { should == '1.html' }
    its(:key) { should == '1' }
  end
end
