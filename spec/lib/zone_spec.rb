require 'spec_helper'

describe zone do
  it { should exist }
  it { should be_allocated }
  describe zone.local_storage do
  	it { should be_truthy }
  end

end
