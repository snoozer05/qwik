require File.join(File.dirname(__FILE__), "..", "spec_helper")
require 'qwik/group'

module QuickML
  describe GroupDB do
    let(:db) { QuickML::GroupDB.new('./.test/data', 'test').tap{|db| db.set_site(@site)} }

    describe "#set_site" do
      describe "with argument site './.test/data/test'" do
        before do
          db.set_site(@memory.farm.get_site('test'))
        end

        it "dirpath should be './.test/data/test'" do
          db.send(:get_dirpath).to_s.should == './.test/data/test'
        end
      end
    end

    describe "#get" do
      describe "with argument :Count" do
        subject { db.get(:Count) }
        it { should be_nil }

        context "called #put" do
          context "with arguments :Count and 'v'" do
            before do
              db.put(:Count, 'v')
            end

            it { should == "v" }

            context "called #add" do
              context "with arguments :Count and 'w'" do
                before do
                  db.add(:Count, 'w')
                end

                it { should == "v\nw\n" }
              end
            end

            context "called Qwik::Page#put_with_time" do
              context "with arguments 'v3' and concrete time" do
                before do
                  page = @site['_GroupCount']
                  page.put_with_time('v3', Time.now)
                end

                it { should == 'v3' }
              end
            end
          end
        end

        describe "access through _GroupCount page" do
          subject{ @site['_GroupCount'] }
          it { should be_nil }

          context "called #put" do
            context "with arguments :Count and 'v2'" do
              before do
                db.put(:Count, 'v2')
              end

              subject{ @site['_GroupCount'].get }
              it { should == 'v2' }
            end
          end
        end
      end
    end

    describe "#exist?" do
      describe "with argument :Count" do
        subject { db.exist?(:Count) }
        it { should be_false }

        context "called #put" do
          context "with arguments :Count and 'v'" do
            before do
              db.put(:Count, 'v')
            end

            it { should be_true }
          end

          context "called #delete" do
            context "with argument :Count" do
              before do
                db.delete(:Count)
              end

              it { should be_false }
            end
          end
        end
      end
    end

    describe "#last_article_time" do
      subject { db.last_article_time }
      it { should be_a_kind_of(Time) }
    end
  end
end
