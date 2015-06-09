require 'rails_helper'

RSpec.describe Account, type: :model do
    subject { FactoryGirl.build(:account) }

    it 'rejects short username' do
        subject.username = 'a'
        expect(subject.valid?).to be_falsy
    end

    it 'rejects long username' do
        subject.username = SecureRandom.hex(21)
        expect(subject.valid?).to be_falsy
    end

    it 'rejects short emails' do
        subject.email = SecureRandom.hex(2)
        expect(subject.valid?).to be_falsy
    end

    it 'rejects long emails' do
        subject.email = SecureRandom.hex(51)
        expect(subject.valid?).to be_falsy
    end

    it 'rejects duplicate username' do
        expect(subject.save).to be_truthy
        another_account = FactoryGirl.build(:account, username: subject.username)
        expect(another_account.valid?).to be_falsy
        expect(another_account.errors).to include(:username)
    end

    it 'rejects duplicate email' do
        expect(subject.save).to be_truthy
        another_account = FactoryGirl.build(:account, email: subject.email)
        expect(another_account.valid?).to be_falsy
        expect(another_account.errors).to include(:email)
    end

    it 'rejects mismatched password' do
        subject.password = subject.password_confirmation = "blahblah"
        subject.save!
        expect {
            Account.for_username(subject.username, "wrongpassword")
        }.to raise_error(IncorrectPasswordError)
    end

    it 'rejects mismatched password' do
        subject.password = subject.password_confirmation = "blahblah"
        subject.save!
        expect {
            Account.for_username(FactoryGirl.generate(:username), "somepassword")
        }.to raise_error(InvalidUsernameError)
    end
end
