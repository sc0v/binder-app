# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

gdrive_doc = "2019-seeds"
gdrive_doc = gdrive_doc + " - "

puts
puts 'Seeding Database...'
puts

puts '  Organizations'

csv_text = File.read(Rails.root.join('lib', 'seeds', gdrive_doc + 'organizations.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  organization_category ||= OrganizationCategory.find_by_name(row['organization_category'].strip)
  organization_category ||= OrganizationCategory.create(name: row['organization_category'].strip, is_building: row['is_building'] == "TRUE")
  if organization_category.is_building != (row['is_building'] == "TRUE")
    puts 'OrganizationCategory is_building inconsistent'
    fail
  end
  Organization.create(name: row['name'].strip, organization_category: organization_category, short_name: row['short_name'])
end

puts '  Participants'

csv_text = File.read(Rails.root.join('lib', 'seeds', gdrive_doc + 'participants.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  organization = Organization.find_by_name(row['organization'].strip)
  if !organization
    puts '    Organization (' + row['organization'].strip + ') does not exist error'
    fail
  end

  participant = Participant.find_by_andrewid(row['andrewid'].strip)
  if !participant
    user = User.create(email: row['andrewid'].strip + "@andrew.cmu.edu")
    if row['admin'] == "TRUE"
      user.add_role :admin
    end
    participant = Participant.create(andrewid: row['andrewid'], user: user)
  end

  Membership.create(organization: organization, participant: participant, title: row['title'], is_booth_chair: row['booth_chair'] == "TRUE")
end

puts '  Organization Status Types'

csv_text = File.read(Rails.root.join('lib', 'seeds', gdrive_doc + 'organization_status_types.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  OrganizationStatusType.create(name: row['name'].strip, display: row['display'] == "TRUE", category: row['category'].strip)
end

puts '  Charge Types'

csv_text = File.read(Rails.root.join('lib', 'seeds', gdrive_doc + 'charge_types.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  ChargeType.create(name: row['name'].strip, description: row['description'] || "", default_amount: Integer(row['default_amount'] || "0"))
end

puts '  Event Types'

csv_text = File.read(Rails.root.join('lib', 'seeds', gdrive_doc + 'event_types.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  EventType.create(name: row['name'].strip, display: row['display'] == "TRUE")
end

puts '  FAQs'

csv_text = File.read(Rails.root.join('lib', 'seeds', gdrive_doc + 'faqs.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  Faq.create(question: row['question'].strip, answer: row['answer'].strip)
end

puts '  Tasks'

csv_text = File.read(Rails.root.join('lib', 'seeds', gdrive_doc + 'tasks.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  Task.create(name: row['name'].strip, description: row['description'].strip, due_at: DateTime.strptime(row['due_at'], '%m/%d/%Y %H:%M:%S'))
end

puts '  Shifts'

csv_text = File.read(Rails.root.join('lib', 'seeds', gdrive_doc + 'shifts.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  organization = Organization.find_by_name(row['organization'].strip)
  if !organization
    puts '    Organization (' + row['organization'].strip + ') does not exist'
    fail
  end

  shift_type ||= ShiftType.find_by_name(row['shift_type'].strip)
  shift_type ||= ShiftType.create(name: row['shift_type'].strip)

  shift = Shift.create(organization: organization, shift_type: shift_type, starts_at: DateTime.strptime(row['starts_at'], '%m/%d/%Y %H:%M:%S'), ends_at: DateTime.strptime(row['ends_at'], '%m/%d/%Y %H:%M:%S'), required_number_of_participants: Integer(row['required_number_of_participants']))

  if (row['andrewid'] || "") != ""
    participant = Participant.find_by_andrewid(row['andrewid'].strip)
    if !participant
      puts '    Participant (' + row['andrewid'] + ') does not exist'
      fail
    end

    ShiftParticipant.create(shift: shift, participant: participant)
  end
end

puts '  Store'

csv_text = File.read(Rails.root.join('lib', 'seeds', gdrive_doc + 'store.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  StoreItem.create(name: row['name'].strip, price: Integer(row['price'] || "0"), quantity: Integer(row['quantity'] || "0"))
end

puts '  Tools'

csv_text = File.read(Rails.root.join('lib', 'seeds', gdrive_doc + 'tools.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  tool_type ||= ToolType.find_by_name(row['tool_type'].strip)
  tool_type ||= ToolType.create(name: row['tool_type'].strip)
  Tool.create(barcode: Integer(row['barcode']), tool_type: tool_type, description: row['description'])
end

puts '  Certifications'
# NOTE: This section also generates the ToolTypes for restricted tools as well
# as creating the ToolTypeCertification which restricts their checkout.  If any
# certification types are missing from the seeds at the time of seeding, these
# will need to be manually created in the database later.

csv_text = File.read(Rails.root.join('lib', 'seeds', gdrive_doc + 'certifications.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|

  certification_type = CertificationType.find_by_name(row['certification'].strip)
  if !certification_type
    tool_type = ToolType.find_by_name(row['certification'].strip)
    if !tool_type
      tool_type = ToolType.create(name: row['certification'].strip)
      puts '    ToolType (' + row['certification'].strip + ') did not exist, created it'
    end

    certification_type = CertificationType.create(name: row['certification'].strip)
    ToolTypeCertification.create(tool_type: tool_type, certification_type: certification_type)
  end

  participant = Participant.find_by_andrewid(row['andrewid'].strip)
  if !participant
    user = User.create(email: row['andrewid'].strip + "@andrew.cmu.edu")
    participant = Participant.create(andrewid: row['andrewid'], user: user)
  end

  Certification.create(participant: participant, certification_type: certification_type)
end

if  Rails.env.development?

  puts '  Development Stuff'

  admin_andrewid = 'rcrown'
  scc_andrewid = 'cbrownel'
  booth_chair_andrewid = 'rpwhite'
  participant_andrewid = 'nharper'

  scc_org = Organization.find_by_name("Spring Carnival Committee")
  dtd_org = Organization.find_by_name("Delta Tau Delta")

  admin_user = User.create({ email: "#{admin_andrewid}@andrew.cmu.edu"})
  admin_user.add_role :admin
  admin = Participant.create({ andrewid: admin_andrewid, user: admin_user })
  Membership.create({ organization: scc_org, participant: admin, title: 'Admin', is_booth_chair: true })

  scc_user = User.create({ email: "#{scc_andrewid}@andrew.cmu.edu"})
  scc = Participant.create({ andrewid: scc_andrewid, user: scc_user })
  Membership.create({ organization: scc_org, participant: scc })

  booth_chair_user = User.create({ email: "#{booth_chair_andrewid}@andrew.cmu.edu"})
  booth_chair = Participant.create({ andrewid: booth_chair_andrewid, user: booth_chair_user })
  Membership.create({ organization: dtd_org, participant: booth_chair, is_booth_chair: true })

  participant_user = User.create({ email: "#{participant_andrewid}@andrew.cmu.edu"})
  participant = Participant.create({ andrewid: participant_andrewid, user: participant_user })
  Membership.create({ organization: dtd_org, participant: participant })
end

puts
