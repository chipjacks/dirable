describe Table do
  let(:parent) { Dirable.root }
  let(:name) { 'table' }
  let(:record_names) { %w(johnny jeffrey) }

  subject { described_class.new(parent, name, Record) }

  before :each do
    parent.dir.mkdir(name)
  end

  after :each do
    parent.dir.rm_r(name)
  end

  describe '#reload' do
    before :each do
      record_names.each do |name|
        subject.dir.mkdir(name)
      end
    end

    it 'initializes new records' do
      expect{
        subject.reload
      }.to change {
        subject.records.size
      }.by(2)
    end

    it 'removes nonexistant records' do
      subject.reload
      subject.dir.rm_r(record_names.first)
      expect{
        subject.reload
      }.to change {
        subject.records.size
      }.by(-1)
    end

    it 'doesn\'t call on_delete' do
      record = subject.add(record_names.first)
      subject.dir.rm_r(record_names.first)
      expect(record).to_not receive(:on_delete)
      subject.reload
    end
  end

  describe '#add' do
    it 'adds a new record' do
      expect {
        subject.add(record_names.first)
      }.to change {
        subject.records.size
      }.by(1)
    end

    it 'adds a new directory' do
      expect {
        subject.add(record_names.first)
      }.to change {
        subject.dir.ls.size
      }.by(1)
    end

    it 'raises an exception if a record already exists with that name' do
      subject.add(record_names.first)
      expect {
        subject.add(record_names.first)
      }.to raise_error /already exists/
    end
  end

  describe '#delete' do
    it 'deletes an existing record' do
      subject.add(record_names.first)
      expect {
        subject.delete(record_names.first)
      }.to change {
        subject.records.size
      }.by(-1)
    end

    it 'deletes the records directory' do
      subject.add(record_names.first)
      expect {
        subject.delete(record_names.first)
      }.to change {
        subject.dir.ls.size
      }.by(-1)
    end

    it 'raises an exception if no record exists with that name' do
      expect {
        subject.delete(record_names.first)
      }.to raise_error /No record exists/
    end

    it 'calls record#on_delete' do
      record = subject.add(record_names.first)
      expect(record).to receive(:on_delete).once
      subject.delete(record_names.first)
    end

  end

  describe '#[]' do
    it 'accesses a record' do
      subject.add(record_names.first)
      expect(subject[record_names.first]).to be_a Record
    end
  end

end
