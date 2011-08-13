require File.join(File.dirname(__FILE__), "..", "spec_helper")

module Qwik
  describe Page, "deals with get" do
    let(:page) { @site.instance_eval{ @pages }.create_new }

    describe "#get" do
      subject { page.get }

      context "after #put" do
        context "with argument 'test1'" do
          before do
            page.put('test1')
          end
          it { should == 'test1' }

          context "and #add with argument 'test2'" do
            before do
              page.add('test2')
            end
            it { should == "test1\ntest2\n" }
          end

          context "and #delete" do
            before do
              page.delete
            end

            it { should == "" }

            context "and #add with argument 't2'" do
              before do
                page.add('t2')
              end
              it { should == "t2\n" }
            end
          end
        end

        context "with argument ''" do
          before do
            page.put('')
          end
          it { should == '' }

          context "and #add with argument 't2'" do
            before do
              page.add('t2')
            end
            it { should == "t2\n" }
          end
        end
      end

      context "after #add" do
        context "with argument 't1'" do
          before do
            page.add('t1')
          end
          it { should == "t1\n" }
        end

        context "with argument ''" do
          before do
            page.add('')
          end
          it { should == "" }
        end
      end

      context "after #store with argument 'test1'" do
        before do
          page.store('test1')
        end
        it { should == 'test1' }
      end

      context "after #put_with_time with argument 'test1' and 0" do
        before do
          page.put_with_time('test1', 0)
        end
        it { should == 'test1' }
      end

      context "after #put_with_md5 with argument 'test1' and concrete md5" do
        before do
          page.put_with_md5('test1', page.get.md5hex)
        end
        it { should == 'test1' }
      end
    end

    describe "#load" do
      subject { page.load }

      context "after #put" do
        context "with argument 'test1'" do
          before do
            page.put('test1')
          end
          it { should == 'test1' }

          context "and #add with argument 'test2'" do
            before do
              page.add('test2')
            end
            it { should == "test1\ntest2\n" }
          end

          context "and #delete" do
            before do
              page.delete
            end

            it { should == "" }

            context "and #add with argument 't2'" do
              before do
                page.add('t2')
              end
              it { should == "t2\n" }
            end
          end
        end

        context "with argument ''" do
          before do
            page.put('')
          end
          it { should == '' }

          context "and #add with argument 't2'" do
            before do
              page.add('t2')
            end
            it { should == "t2\n" }
          end
        end
      end

      context "after #add" do
        context "with argument 't1'" do
          before do
            page.add('t1')
          end
          it { should == "t1\n" }
        end

        context "with argument ''" do
          before do
            page.add('')
          end
          it { should == "" }
        end
      end

      context "after #store with argument 'test1'" do
        before do
          page.store('test1')
        end
        it { should == 'test1' }
      end

      context "after #put_with_time with argument 'test1' and 0" do
        before do
          page.put_with_time('test1', 0)
        end
        it { should == 'test1' }
      end

      context "after #put_with_md5 with argument 'test1' and concrete md5" do
        before do
          page.put_with_md5('test1', page.get.md5hex)
        end
        it { should == 'test1' }
      end
    end

    describe "#mtime" do
      subject { page.mtime }

      context "after #put_with_time with argument 'test1' and 10" do
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

    describe "#size" do
      subject { page.size }
      it { should be_zero }

      context "after #store" do
        context "with argument 't'" do
          before do
            page.store('t')
          end
          it { should == 1 }
        end

        context "with argument 'test'" do
          before do
            page.store('test')
          end
          it { should == 4 }
        end
      end
    end
  end
end
