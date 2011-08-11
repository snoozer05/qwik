require File.join(File.dirname(__FILE__), "..", "spec_helper")
require 'qwik/group'

module QuickML
  describe Group do
    def setup_config
      Qwik::Config.new.tap{ |c|
        c[:logger] = QuickML::MockLogger.new
        c.update(Qwik::Config::DebugConfig)
        c.update(Qwik::Config::TestConfig)
        QuickML::ServerMemory.init_mutex(c)
        QuickML::ServerMemory.init_catalog(c)
      }
    end

    describe ".get_name" do
      it "return ['test', 'example.com'] if called with 'test@example.com'" do
        QuickML::Group.get_name('test@example.com').should == ['test', 'example.com']
      end
    end

    describe ".valid_name?" do
      it "return true if called with 't'" do
        QuickML::Group.valid_name?('t').should be_true
      end

      it "return true if called with 't-t'" do
        QuickML::Group.valid_name?('t-t').should be_true
      end

      it "return false if called with 't_t'" do
        QuickML::Group.valid_name?('t_t').should be_false
      end

      it "return false if called with 't.t'" do
        QuickML::Group.valid_name?('t.t').should be_false
      end

      it "return false if called with 'test@example.com'" do
        QuickML::Group.valid_name?('test@example.com').should be_false
      end

      it "return false if called with 'test@qwik@jp'" do
        QuickML::Group.valid_name?('test@qwik@jp').should be_false
      end

      it "return true if called with 'test'" do
        QuickML::Group.valid_name?('test').should be_true
      end

      it "return false if called with 'te.st'" do
        QuickML::Group.valid_name?('te.st').should be_false
      end
    end

    context "when created by test@example.com" do
      before do
        @config = setup_config
        @group = QuickML::Group.new(@config, 'test@example.com')
      end

      subject { @group }

      its(:name) { should eq 'test' }
      its(:address) { should eq 'test@example.com' }
      its(:return_address) { should eq 'test=return@example.com' }
      its(:count) { should be_zero }
      its(:charset) { should be_nil  }
    end
  end
end
