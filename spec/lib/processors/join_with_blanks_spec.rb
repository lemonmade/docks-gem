require 'spec_helper'

describe Docks::Processors::JoinWithBlanks do
  subject { Docks::Processors::JoinWithBlanks }

  it 'correctly joins an array with blanks' do
    array = %w(one two three)
    expect(subject.process(array)).to eq array.join('')
  end

  it 'correctly returns a non-array argument' do
    non_array = "I'm not an array!"
    expect(subject.process(non_array)).to eq non_array
  end

  it 'correctly returns nil for an empty array' do
    expect(subject.process([])).to be nil
  end

  it 'correctly returns nil for an array containing only whitespace strings' do
    expect(subject.process([' '])).to be nil
    expect(subject.process([' ', '   '])).to be nil
  end
end
