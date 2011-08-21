require File.join(File.dirname(__FILE__), "..", "spec_helper")

module Qwik
  describe PageFiles do
    let(:test_path) { "./.test/" }
    let(:file) { Qwik::PageFiles.new(test_path, '1') }
    before do
      test_path.path.teardown
    end

    describe "#fput" do
      describe "with japanese filename" do
        subject { file.exist? "\202\240.txt" }
        before do
          file.fput("\202\240.txt", 't')
        end
        it "should created file" do
          should be_true
        end

        describe "twice" do
          subject { file.exist? "1-\202\240.txt" }
          before do
            file.fput("\202\240.txt", 't')
          end
          it "should created file '1-xx'" do
            should be_true
          end
        end
      end
    end

    describe "#exist?" do
      describe "with argument 't.txt'" do
        subject { file.exist? 't.txt' }
        it { should be_false }

        context "after #fput with 't.txt' and 't'" do
          before do
            file.fput('t.txt', 't')
          end
          it { should be_true }

          context "and #delete with 't.txt'" do
            before do
              file.delete('t.txt')
            end
            it { should be_false }
          end
        end
      end
    end

    describe "#get" do
      describe "with argument 't.txt'" do
        subject { file.get 't.txt' }
        it { expect{ subject }.to.should raise_error }

        context "after #fput with 't.txt' and 't'" do
          before do
            file.fput('t.txt', 't')
          end
          it { should == 't' }

          context "and #delete with 't.txt'" do
            before do
              file.delete('t.txt')
            end
            it { expect{ subject }.to.should raise_error }
          end
        end
      end
    end

    describe "#list" do
      subject { file.list }
      it { should have(0).items }

      context "after #fput with 't.txt' and 't'" do
        before do
          file.fput('t.txt', 't')
        end
        it { should have(1).items }

        context "and #delete with 't.txt'" do
          before do
            file.delete('t.txt')
          end
          it { should have(0).items }
        end
      end
    end

    describe "#total" do
      subject { file.total }
      it { should be_zero }

      context "after #fput with 't.txt' and 't'" do
        before do
          file.fput('t.txt', 't')
        end
        it { should == 1 }

        context "and #fput with 't10.txt' and 't'*10 " do
          before do
            file.fput('t10.txt', 't'*10)
          end
          it { should == 11 }
        end
      end

      context "and #fput with 't10.txt' and 't'*10 " do
        before do
          file.fput('t10.txt', 't'*10)
        end
        it { should == 10 }

        context "and #delete with 't10.txt'" do
          before do
            file.delete('t10.txt')
          end
          it { should be_zero }
        end
      end
    end
  end
end
