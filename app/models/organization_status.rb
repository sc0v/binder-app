# ## Schema Information
#
# Table name: `organization_statuses`
#
# ### Columns
#
# Name                               | Type               | Attributes
# ---------------------------------- | ------------------ | ---------------------------
# **`active`**                       | `boolean`          | `default(TRUE)`
# **`created_at`**                   | `datetime`         |
# **`description`**                  | `string(255)`      |
# **`id`**                           | `integer`          | `not null, primary key`
# **`organization_id`**              | `integer`          |
# **`organization_status_type_id`**  | `integer`          |
# **`participant_id`**               | `integer`          |
# **`updated_at`**                   | `datetime`         |
#
# ### Indexes
#
# * `index_organization_statuses_on_organization_id`:
#     * **`organization_id`**
#

class OrganizationStatus < ActiveRecord::Base
  validates_presence_of :organization_status_type, :organization, :participant
  validates_associated :organization_status_type, :organization, :participant

  belongs_to :organization_status_type
  belongs_to :organization, :touch => true
  belongs_to :participant

  scope :displayable, -> { joins(:organization_status_type).where('organization_status_types.display = ?', true) }
  scope :electrical, -> { joins(:organization_status_type).where('organization_status_types.category = ?', 'electrical') }
  scope :structural, -> { joins(:organization_status_type).where('organization_status_types.category = ?', 'structural') }
  scope :general, -> { joins(:organization_status_type).where('organization_status_types.category = ?', 'general') }
  scope :active,      -> { where(active: true) }
  scope :inactive,    -> { where(active: false) }
end
