require_relative "max"

module Calculator
  describe Max do
    subject { Max.new }

    context 'for valid inputs' do
      it "returns correct answer for a tie" do
        expect(subject.run(4, 4)).to eq(4)
      end

      it "returns correct answer when first is larger" do
        expect(subject.run(4, 3)).to eq(4)
      end

      it "returns correct answer when last is larger" do
        expect(subject.run(3, 4)).to eq(4)
      end
    end

    context 'for invalid inputs' do
      it 'should explode loudly' do
        expect { subject.run('foo', :bar) }.to raise_error
      end
    end
  end
end
