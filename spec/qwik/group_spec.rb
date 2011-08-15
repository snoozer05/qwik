require File.join(File.dirname(__FILE__), "..", "spec_helper")

module QuickML
  describe Group do
    describe ".get_name" do
      describe "with argument 'test@example.com'" do
        subject { QuickML::Group.get_name('test@example.com') }
        it { should == ['test', 'example.com'] }
      end
    end

    describe ".valid_name?" do
      describe "with argument 't'" do
        subject { QuickML::Group.valid_name?('t') }
        it { should be_true }
      end

      describe "with argument 't-t'" do
        subject { QuickML::Group.valid_name?('t-t') }
        it { should be_true }
      end

      describe "with argument 't_t'" do
        subject { QuickML::Group.valid_name?('t_t') }
        it { should be_false }
      end

      describe "with argument 't.t'" do
        subject { QuickML::Group.valid_name?('t.t') }
        it { should be_false }
      end

      describe "with argument 'test@example.com'" do
        subject { QuickML::Group.valid_name?('test@example.com') }
        it { should be_false }
      end

      describe "with argument 'test@qwik@jp'" do
        subject { QuickML::Group.valid_name?('test@qwik@jp') }
        it { should be_false }
      end

      describe "with argument 'test'" do
        subject { QuickML::Group.valid_name?('test') }
        it { should be_true }
      end

      describe "with argument 'te.st'" do
        subject { QuickML::Group.valid_name?('te.st') }
        it { should be_false }
      end
    end

    context "when created by test@example.com" do
      let(:group) { QuickML::Group.new(@config, 'test@example.com') }

      subject { group }
      its(:name) { should eq 'test' }
      its(:address) { should eq 'test@example.com' }
      its(:return_address) { should eq 'test=return@example.com' }
      its(:count) { should be_zero }
      its(:charset) { should be_nil  }
    end
  end
end
