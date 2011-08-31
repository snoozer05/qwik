#encoding: utf-8
require File.join(File.dirname(__FILE__), "..", "spec_helper")
require 'nkf'

module Qwik
  describe GetText do
    let(:target) do
      Object.new.tap {|obj|
        obj.extend(GetText)
      }
    end

    describe "#gettext" do
      describe "with argument 'hello'" do
        subject { NKF.nkf('-w', target.gettext('hello')) }
        it { should == 'hello' }

        context "after #set_catalog to 'ja'" do
          before do
            $KCODE = 'S'
            cf = Qwik::CatalogFactory.new
            cf.load_all_here('catalog-??.rb')
            target.set_catalog(cf.get_catalog('ja'))
            $KCODE = 'U'
          end
          it { should == "こんにちは" }
        end
      end
    end

    describe "#_" do
      describe "with argument 'hello'" do
        subject { NKF.nkf('-w', target._('hello')) }
        it { should == 'hello' }

        context "after #set_catalog to 'ja'" do
          before do
            $KCODE = 'S'
            cf = Qwik::CatalogFactory.new
            cf.load_all_here('catalog-??.rb')
            target.set_catalog(cf.get_catalog('ja'))
            $KCODE = 'U'
          end
          it { should == "こんにちは" }
        end
      end
    end
  end
end

