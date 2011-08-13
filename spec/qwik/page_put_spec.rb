require File.join(File.dirname(__FILE__), "..", "spec_helper")

RSpec::Matchers.define :update_page_data_to do |expected|
  match do |actual|
    actual == expected
  end
end

module Qwik
  describe Page, "deals with put" do
    let(:pages){ @site.instance_eval{ @pages }}
    let(:page) { pages.create_new }
    subject { page.get }

    describe "#put" do
      describe "with argument 'test1'" do
        before do
          page.put('test1')
        end
        it { should update_page_data_to 'test1' }

        describe "and call #put" do
          describe "with argument 'test2'" do
            before do
              page.put('test2')
            end
            it { should update_page_data_to "test2" }
          end
        end

        describe "and call #add" do
          describe "with argument 'test2'" do
            before do
              page.add('test2')
            end
            it { should update_page_data_to "test1\ntest2\n" }
          end
        end
      end

      describe "with argument ''" do
        before do
          page.put('')
        end
        it { should update_page_data_to '' }
      end
    end

    describe "#put_with_time" do
      describe "with argument 'test1' and 0" do
        before do
          page.put_with_time('test1', 0)
        end
        it { should update_page_data_to 'test1' }
      end

      describe "with argument '' and 0" do
        before do
          page.put_with_time('', 0)
        end
        it { should update_page_data_to '' }
      end
    end

    describe "#store" do
      describe "with argument 'test1'" do
        before do
          page.store('test1')
        end
        it { should update_page_data_to 'test1' }
      end

      describe "with argument ''" do
        before do
          page.store('')
        end
        it { should update_page_data_to '' }
      end
    end

    describe "#add" do
      describe "with argument 'test1'" do
        before do
          page.add('test1')
        end
        it { should update_page_data_to "test1\n" }
      end

      describe "with argument ''" do
        before do
          page.add('')
        end
        it { should update_page_data_to '' }
      end
    end

    describe "#delete" do
      before do
        page.put('test1')
        page.delete
      end
      it { should update_page_data_to '' }

      describe "and call #put" do
        describe "with argument 'test2'" do
          before do
            page.put('test2')
          end
          it { should update_page_data_to "test2" }
        end
      end

      describe "and call #add" do
        describe "with argument 'test2'" do
          before do
            page.add('test2')
          end
          it { should update_page_data_to "test2\n" }
        end
      end
    end

    describe "#put_with_md5" do
      describe "with argument 'test1' and concrete md5" do
        before do
          page.put_with_md5('test1', page.get.md5hex)
        end
        it { should update_page_data_to 'test1' }
      end

      describe "with arguments 'test1' and invalid value as md5" do
        subject { expect { page.put_with_md5('test1', 'somethingwrong').to }}
        it { should raise_error(Qwik::PageCollisionError) }
      end
    end

    describe "#mtime" do
      subject { page.mtime }

      context "with argument 'test1' and 10" do
        before do
          page.put_with_time('test1', 10)
        end
        it { subject.to_i.should == 10 }
        it { should be_a_kind_of(Time) }

        context "and #delete page" do
          before do
            page.delete
          end
          it { subject.to_i.should == 0 }
          it { should be_a_kind_of(Time) }
        end
      end
    end
  end
end
