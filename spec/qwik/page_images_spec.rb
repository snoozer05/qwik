require File.join(File.dirname(__FILE__), "..", "spec_helper")

module Qwik
  describe PageFiles, "deals with images" do
    let(:png_data) { "\211PNG\r\n\032\n\000\000\000\rIHDR\000\000\000\001\000\000\000\001\010\002\000\000\000\220wS\336\000\000\000\fIDATx\332c\370\377\377?\000\005\376\002\3763\022\225\024\000\000\000\000IEND\256B`\202" }
    let(:test_path) { "./.test/" }
    let(:file) { Qwik::PageFiles.new(test_path, '1') }
    before do
      test_path.path.teardown
    end

    describe ".is_image?" do
      describe "with argument 'jpg'" do
        subject { PageFiles.is_image?('jpg') }
        it { should be_true }
      end
      describe "with argument 'jpeg'" do
        subject { PageFiles.is_image?('jpeg') }
        it { should be_true }
      end
      describe "with argument 'JPG'" do
        subject { PageFiles.is_image?('JPG') }
        it { should be_true }
      end
      describe "with argument 'png'" do
        subject { PageFiles.is_image?('png') }
        it { should be_true }
      end
      describe "with argument 'gif'" do
        subject { PageFiles.is_image?('gif') }
        it { should be_true }
      end
      describe "with argument 'bmp'" do
        subject { PageFiles.is_image?('bmp') }
        it { should be_true }
      end
      describe "with argument 'ico'" do
        subject { PageFiles.is_image?('ico') }
        it { should be_true }
      end
      describe "with argument 'ppm'" do
        subject { PageFiles.is_image?('ppm') }
        it { should be_true }
      end
      describe "with argument 'pdf'" do
        subject { PageFiles.is_image?('pdf') }
        it { should be_false }
      end
    end

    describe "#image_list" do
      subject { file.image_list }
      it { should have(0).items }

      context "when add a image through #fput" do
        before do
          file.fput('1.jpg', png_data)
        end
        it { should have(1).items  }
      end

      context "when add two images through #fput" do
        before do
          file.fput('1.jpg', png_data)
          file.fput('2.jpg', png_data)
        end
        it { should have(2).items  }
      end
    end

    describe "#exist?" do
      describe "with argument '.thumb/1.jpg'" do
        subject { file.exist? '.thumb/1.jpg' }
        it { should be_false }

        context "after #add image as 1.jpg" do
          before do
            file.fput('1.jpg', png_data)
            $test = false
          end

          context "and after #generate_thumb('1.jpg')" do
            before do
              file.generate_thumb('1.jpg')
            end
            it { should be_true }
          end

          context "and after #generate_all_thumb" do
            before do
              file.generate_all_thumb
            end
            it { should be_true }
          end

          context "and after #generate_screen('1.jpg')" do
            before do
              file.generate_screen('1.jpg')
            end
            it { should be_false }
          end

          context "and after #generate_all_screen" do
            before do
              file.generate_all_screen
            end
            it { should be_false }
          end
        end
      end

      describe "with argument '.screen/1.jpg'" do
        subject { file.exist? '.screen/1.jpg' }
        it { should be_false }

        context "after #add image as 1.jpg" do
          before do
            file.fput('1.jpg', png_data)
            $test = false
          end

          context "and after #generate_thumb('1.jpg')" do
            before do
              file.generate_thumb('1.jpg')
            end
            it { should be_false }
          end

          context "and after #generate_all_thumb" do
            before do
              file.generate_all_thumb
            end
            it { should be_false }
          end



          context "and after #generate_screen('1.jpg')" do
            before do
              file.generate_screen('1.jpg')
            end
            it { should be_true }
          end

          context "and after #generate_all_screen" do
            before do
              file.generate_all_screen
            end
            it { should be_true }
          end
        end
      end
    end
  end
end
