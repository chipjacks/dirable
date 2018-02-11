describe Config do
  subject { described_class.new }

  describe "#fs_interface" do
    it "default value is LocalFS" do
      expect(subject.fs_interface).to eq(LocalFS)
    end
  end

  describe "#root_dir" do
    it "has a default value" do
      expect(subject.root_dir).to eq('/tmp/dirable')
    end
  end

  describe "#root_class" do
    it "has no default value" do
      expect(subject.root_class).to be_nil
    end
  end
end
