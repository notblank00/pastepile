require 'rails_helper'

describe Paste, type: :model do
  it 'shoud validate a normal paste' do
    expect(Paste.new(content: 'content')).to be_valid
  end

  it 'should not validate empty pastes' do
    expect(Paste.new).not_to be_valid
  end
end
