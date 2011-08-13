# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__), "..", "spec_helper")

module Qwik
  describe Page, "deals with get" do
    describe ".valid_as_pagekey?" do
      describe "with arguments 't'" do
        subject { Qwik::Page.valid_as_pagekey?('t') }
        it { should be_true }
      end

      describe "with arguments 't t'" do
        subject { Qwik::Page.valid_as_pagekey?('t t') }
        it { should be_false }
      end
    end

    describe ".get_first_line" do
      describe "with arguments ''" do
        subject { Qwik::Page.get_first_line('') }
        it { should == '' }
      end

      describe "with arguments '\\n'" do
        subject { Qwik::Page.get_first_line("\n") }
        it { should == '' }
      end

      describe "with arguments 'line1'" do
        subject { Qwik::Page.get_first_line('line1') }
        it { should == 'line1' }
      end

      describe "with arguments 'l1\\nl2\\n'" do
        subject { Qwik::Page.get_first_line("l1\nl2\n") }
        it { should == 'l1' }
      end

      describe "with arguments '\\nline2\\n'" do
        subject { Qwik::Page.get_first_line("\nline2\n") }
        it { should == '' }
      end

      describe "with arguments '# c\\nl1\\nl2\\n'" do
        subject { Qwik::Page.get_first_line("# c\nl1\nl2\n") }
        it { should == 'l1' }
      end
    end

    describe ".get_title" do
      describe "with arguments nil" do
        subject { Qwik::Page.get_title(nil) }
        it { should be_nil }
      end
      describe "with arguments ''" do
        subject { Qwik::Page.get_title("") }
        it { should be_nil }
      end
      describe "with arguments 't'" do
        subject { Qwik::Page.get_title("t") }
        it { should be_nil  } # must begin with *
      end
      describe "with arguments '-t'" do
        subject { Qwik::Page.get_title("-t") }
        it { should be_nil }
      end
      describe "with arguments 'b1\\nb2'" do
        subject { Qwik::Page.get_title("b1\nb2") }
        it { should be_nil }
      end
      describe "with arguments '** t'" do
        subject { Qwik::Page.get_title("** t") }
        it { should be_nil } # must be h2 level header.
      end
      describe "with arguments '**t'" do
        subject { Qwik::Page.get_title("**t") }
        it { should be_nil }
      end
      describe "with arguments '** t\\nb'" do
        subject { Qwik::Page.get_title("** t\nb") }
        it { should be_nil }
      end
      describe "with arguments '*'" do
        subject { Qwik::Page.get_title("*") }
        it { should be_nil } # empty
      end
      describe "with arguments '* '" do
        subject { Qwik::Page.get_title("* ") }
        it { should be_nil }
      end
      describe "with arguments '*  '" do
        subject { Qwik::Page.get_title("*  ") }
        it { should be_nil }
      end
      describe "with arguments '*t'" do
        subject { Qwik::Page.get_title("*t") }
        it { should == ['t', []] }
      end
      describe "with arguments '* t'" do
        subject { Qwik::Page.get_title("* t") }
        it { should == ['t', []] }
      end
      describe "with arguments '*t '" do
        subject { Qwik::Page.get_title("*t ") }
        it { should == ['t', []] }
      end
      describe "with arguments '* t '" do
        subject { Qwik::Page.get_title("* t ") }
        it { should == ['t', []] }
      end
      describe "with arguments '*a b'" do
        subject { Qwik::Page.get_title("*a b") }
        it { should == ['a b', []] }
      end
      describe "with arguments '* a b'" do
        subject { Qwik::Page.get_title("* a b") }
        it { should == ['a b', []] }
      end
      describe "with arguments '* *t'" do
        subject { Qwik::Page.get_title("* *t") }
        it { should == ['*t', []] } # uum...
      end
      describe "with arguments '*- t'" do
        subject { Qwik::Page.get_title("*- t") }
        it { should == ['- t', []] } # uum...
      end
      describe "with arguments '* t\\nb'" do
        subject { Qwik::Page.get_title("* t\nb") }
        it { should == ['t', []] }
      end
      describe "with arguments '# c\\n* t\\nb'" do
        subject { Qwik::Page.get_title("# c\n* t\nb") }
        it { should == ['t', []] }
      end
      describe "with arguments '*字'" do
        subject { Qwik::Page.get_title("*字") }
        it { should == ["字", []] }
      end
      describe "with arguments '*あ'" do
        subject { Qwik::Page.get_title("*あ") }
        it { should == ["あ", []] }
      end
      describe "with arguments '* コ'" do
        subject { Qwik::Page.get_title("* コ") }
        it { should == ["コ", []] }
      end
      describe "with arguments '* コ\\n{{mail(user@e.com)\\nあ\\n\\n}}\\n'" do
        subject { Qwik::Page.get_title("* コ\n{{mail(user@e.com)\nあ\n\n}}\n") }
        it { should == ["コ", []] }
      end
      describe "with arguments '* [tag] t'" do
        subject { Qwik::Page.get_title("* [tag] t") }
        it { should == ['t', ['tag']] }
      end
      describe "with arguments '* [t1][t2] t'" do
        subject { Qwik::Page.get_title("* [t1][t2] t") }
        it { should == ['t', ['t1', 't2']] }
      end
      describe "with arguments '* [tag]'" do
        subject { Qwik::Page.get_title("* [tag]") }
        it { should == ['[tag]', []] }
      end
      describe "with arguments '* [t1][t2]'" do
        subject { Qwik::Page.get_title("* [t1][t2]") }
        it { should == ['[t2]', ['t1']] }
      end
      describe "with arguments '* [2001-02-03] t'" do
        subject { Qwik::Page.get_title("* [2001-02-03] t") }
        it { should == ['t', ['2001-02-03']] }
      end
    end

    describe ".get_body" do
      describe "with arguments '* t\\nb'" do
        subject { Qwik::Page.get_body("* t\nb") }
        it { should == 'b' }
      end

      describe "with arguments '* t\\n\\nb'" do
        subject { Qwik::Page.get_body("* t\n\nb") }
        it { should == 'b' }
      end

      describe "with arguments 'b1\\nb2'" do
        subject { Qwik::Page.get_body("b1\nb2") }
        it { should == "b1\nb2" }
      end

      describe "with arguments '** t\\nb'" do
        subject { Qwik::Page.get_body("** t\nb") }
        it { should == "** t\nb" }
      end

      describe "with arguments '* t\\n* t2'" do
        subject { Qwik::Page.get_body("* t\n* t2") }
        it { should == '* t2' }
      end

      describe "with arguments '* t\\n\\n* t2'" do
        subject { Qwik::Page.get_body("* t\n\n* t2") }
        it { should == '* t2' }
      end

      describe "with arguments 'a\\n#b\\nc'" do
        subject { Qwik::Page.get_body("a\n#b\nc") }
        it { should == "a\n#b\nc" }
      end
    end

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
