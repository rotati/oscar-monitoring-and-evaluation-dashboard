require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do

  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:roles) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:first_name) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_inclusion_of(:roles).in_array(User::ROLES) }
  end
end
