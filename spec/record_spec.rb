describe Record do
  let(:parent) { Dirable.root }
  let(:name) { 'record' }

  subject { described_class.new(parent, name) }

  before :each do
    parent.dir.mkdir(name)
  end

  after :each do
    parent.dir.rm_r(name)
  end

  describe '#has_many' do
    let(:table) { 'children' }

    it 'defines a #children method' do
      subject.has_many(table, Record)
      expect(subject.children).to be_a Table
    end

    it 'doesnt access other records children' do
      parent.dir.mkdir('other_record')
      other = described_class.new(parent, 'other_record')
      subject.has_many(table, Record)
      other.has_many(table, Record)
      expect(subject.children.dir.path).to match /\/record\/children$/
      expect(other.children.dir.path).to match /\/other_record\/children$/
      parent.dir.rm_r('other_record')
    end

    it 'reloads the table each time it is accessed' do
      subject.has_many(table, Record)
      expect(subject.children.size).to eq(0)
      subject.children.dir.mkdir('joe')
      expect(subject.children.size).to eq(1)
    end

  end

  describe '#has_one' do

    it 'initializes a dirable' do
      subject.has_one('child', Record)
      expect(subject.child).to be_a Record
      expect(subject.child.name).to eq 'child'
    end

    it 'doesnt access other records child' do
      parent.dir.mkdir('other_record')
      other = described_class.new(parent, 'other_record')
      subject.has_one('child', Record)
      other.has_one('child', Record)
      expect(subject.child.dir.path).to match /\/record\/child$/
      expect(other.child.dir.path).to match /\/other_record\/child$/
      parent.dir.rm_r('other_record')
    end
  end

  describe '#has_attribute' do
    let(:attribute) { 'attribute' }

    it 'defines a getter and setter method' do
      subject.has_attribute(attribute)
      subject.attribute = 'value'
      expect(subject.attribute).to eq 'value'
    end

    it 'reloads the attribute each time it is accessed' do
      subject.has_attribute(attribute)
      subject.attribute = 'value'
      expect(subject.attribute).to eq 'value'
      subject.dir.store('attribute', 'new_value')
      expect(subject.attribute).to eq 'new_value'
    end

    it 'doesnt access other records attributes' do
      parent.dir.mkdir('other_record')
      other = described_class.new(parent, 'other_record')
      subject.has_attribute('id')
      other.has_attribute('id')
      other.id = '12'
      expect(subject.id).to eq nil
      expect(other.id).to eq '12'
      parent.dir.rm_r('other_record')
    end
  end

end
