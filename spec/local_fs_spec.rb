require_relative 'shared_examples/fs_interface'

describe LocalFS do
  it_behaves_like 'a filesystem interface'
  it_behaves_like 'a filesystem implementation'
end
