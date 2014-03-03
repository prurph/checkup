require 'spec_helper'

describe Event do
  it { should belong_to(:tag).touch(true) }
end
