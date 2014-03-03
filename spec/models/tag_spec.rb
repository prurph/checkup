require 'spec_helper'

describe Tag do
  it { should have_many(:events) }
  it { should belong_to(:category).touch(true) }
end
