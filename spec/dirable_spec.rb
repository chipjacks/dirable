describe Dirable do

  describe '#config' do
    it 'is a config object' do
      expect(described_class.config).to be_a Config
    end
  end

  describe '#configure' do
    it 'updates the config' do
      expect {
        described_class.configure do |config|
          config.root_dir = '/tmp/dirable_test2'
        end
      }.to change {
        described_class.config.root_dir
      }
    end
  end

  describe '#fs' do
    it 'is a fileystem interface' do
      expect(described_class.fs).to be_a LocalFS
    end
  end

  describe '#root' do
    it 'initializes the Dirable::Record' do
      expect(described_class.root).to be_a Dirable::Record
    end
  end
end
