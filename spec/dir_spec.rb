describe Dirable::Dir do

  subject(:dir) { described_class.new(Dirable.config.root_dir) }

  describe '#store and #fetch' do
    it 'stores and fetches a value for a key' do
      key, val = 'oozie-job-id', '271828'
      subject.store(key, val)
      expect(subject.fetch(key)).to eq(val)
    end
  end

  describe '#fetch' do
    it 'raises an error when file is a directory' do
      subject.mkdir('cats')
      expect{ subject.fetch('cats') }.to raise_error(InvalidOpError)
    end
  end

end
