# ## Schema Information
#
# Table name: `organization_status_types`
#
# ### Columns
#
# Name            | Type               | Attributes
# --------------- | ------------------ | ---------------------------
# **`active`**    | `boolean`          | `default(TRUE)`
# **`category`**  | `string(255)`      |
# **`display`**   | `boolean`          |
# **`id`**        | `integer`          | `not null, primary key`
# **`name`**      | `string(255)`      |
#

require 'test_helper'

class OrganizationStatusTypeTest < ActiveSupport::TestCase

  # Relationships
  should have_many(:organization_statuses)

  # Validations
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name)

  context 'With a proper context, ' do
    setup do
      @type1 = FactoryGirl.create(:organization_status_type)
      @person = FactoryGirl.create(:participant)
      @org = FactoryGirl.create(:organization)
      @status = FactoryGirl.create(:organization_status,
                                  participant: @person, organization: @org, organization_status_type: @type1)
    end

    teardown do
      @type1 = nil
      @person = nil
      @org = nil
      @status = nil
    end
    #
    should 'show that all factories are properly created' do
      assert_equal 1, OrganizationStatusType.all.size
    end

    # Dependency
    should 'delete status if status type is destroyed' do
      @type1.update_attribute(:display, true)
      assert(@status.valid?)
      assert_equal 1, OrganizationStatus.all.size

      @type1.destroy
      assert_equal 0, OrganizationStatus.all.size
    end
  end

end
