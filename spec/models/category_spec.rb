require 'spec_helper'

describe Category do
  it { should have_many(:tags) }
  it { should belong_to(:user) }
end
