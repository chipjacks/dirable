describe Attribute do
  let(:parent) { Dirable.root }
  let(:name) { 'attribute' }

  subject { described_class.new(parent, name) }

  after :each do
    parent.dir.rm_r(name)
  end

  describe '#set' do
    it 'persists the value' do
      expect(Dirable.fs).to receive(:append).with(anything, 'value')
      subject.set('value')
    end
  end

  describe '#get' do
    before :each do
      subject.set('value')
    end

    it 'returns the value' do
      expect(subject.get).to eq 'value'
    end
  end

  describe '#reload' do
    it 'loads the value from the fs' do
      expect(Dirable.fs).to receive(:tip_of_tail).twice
      subject.reload
    end
  end

end
