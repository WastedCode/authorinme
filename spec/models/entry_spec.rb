require 'rails_helper'

RSpec.describe Entry, type: :model do
    subject { FactoryGirl.build(:entry) }

    it 'rejects empty title' do
        subject.title = ''
        expect(subject.valid?).to be_falsy
        expect(subject.errors).to include(:title)
    end

    it 'rejects empty contents' do
        subject.contents = ''
        expect(subject.valid?).to be_falsy
        expect(subject.errors).to include(:contents)
    end

    it 'rejects invalid account id' do
        subject.account_id = -1
        expect(subject.valid?).to be_falsy
        expect(subject.errors).to include(:account)
    end
end

