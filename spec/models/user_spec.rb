# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:user) { create(:user) }

  it 'returns user\'s name' do
    expect(user.username).to eq('Walter White')
  end

  it 'returns user\'s email' do
    expect(user.email).to be_an_instance_of(String)
  end

  describe 'validation' do
    it 'returns true for the email' do
      expect(user.email.present?).to be true
    end

    it 'returns true for th invalide user' do
      invalid_mail = %w[mailamail.com mail.com@mail mailmailcom].sample
      user.email = invalid_mail
      expect(user.invalid?).to be true
    end

    it 'returns true for the role' do
      expect(user.role.present?).to be true
    end

    it 'returns true for the user' do
      user.password = ''
      expect(user.invalid?).to be true
    end

    it 'returns false for the user' do
      invalid_password = %w[123 hello 123hello !hel12H].sample
      user.password = invalid_password
      expect(user.invalid?).to be true
    end

    it { is_expected.to have_many :questions }
    it { is_expected.to have_many :answers }
    it { is_expected.to have_many :comments }
  end
end
