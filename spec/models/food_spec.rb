require 'rails_helper'

RSpec.describe Food, type: :model do
  it { should belong_to(:vendor) }
  it { should have_many(:reviews) }
  it { should validate_presence_of(:name) }
end
