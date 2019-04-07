require 'test_helper'

class CertificationTypeTest < ActiveSupport::TestCase
  should validate_presence_of(:name)

  context "within Certification Type Context, " do
    setup do
      @charge1 = FactoryGirl.create(:charge_type)
    end

    should "show that all factories are properly created" do
      assert_equal 1, ChargeType.all.size
    end

    should "prevent creation of charge_types with non-unique names" do
      @charge2 = FactoryGirl.build(:charge_type, name: @charge1.name)
      deny @charge2.valid?
    end
  end

end
