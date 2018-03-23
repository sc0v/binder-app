# ## Schema Information
#
# Table name: `organization_lists`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`andrew_id`**        | `string`           |
# **`created_at`**       | `datetime`         | `not null`
# **`id`**               | `integer`          | `not null, primary key`
# **`organization_id`**  | `integer`          |
# **`updated_at`**       | `datetime`         | `not null`
#

class OrganizationList < ActiveRecord::Base
require 'csv'
belongs_to :organization

scope :user_orgs, ->(and_id) { where(andrew_id: and_id) }


def self.import (org, file)
	CSV.foreach(file.path, headers: true) do |row|
		OrganizationList.create!(organization_id: org, andrew_id: row['andrew_id'].strip)
	end
end
end