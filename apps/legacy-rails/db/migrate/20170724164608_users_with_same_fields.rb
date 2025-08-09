class UsersWithSameFields < ActiveRecord::Migration

  def up
    User.find_each do |user|
      cd = ContactDetails.find_or_create_by user: user
      if ad = AdminDetails.find_by_user_id(user.id)
        cd.update_attributes phone: ad.phone, sex: ad.sex, work: ad.work, education: ad.education, birth_day: ad.birth_day,
          birth_year: ad.birth_year, mobile_phone: ad.mobile_phone, relationship: ad.relationship, hometown: ad.hometown
      end
    end
    change_table :contact_details do |t|
      t.remove :from, :user_type
    end
    drop_table :admin_details
  end

  def down
    change_table :contact_details do |t|
      t.string :from
      t.string :user_type
    end
    create_table :admin_details do |t|
      t.integer  :user_id
      t.string   :title_position
      t.string   :department
      t.string   :phone
      t.string   :extension
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :sex
      t.string   :work, default: 'Demo management'
      t.string   :education
      t.date     :birth_day
      t.integer  :birth_year
      t.string   :mobile_phone
      t.string   :relationship
      t.string   :hometown
    end
    User.where(role: 'administrator') do |user|
      cd = user.contact_details
      AdminDetails.create user: user, phone: cd.phone, sex: cd.sex, work: cd.work, education: cd.education, birth_day: cd.birth_day,
        birth_year: cd.birth_year, mobile_phone: cd.mobile_phone, relationship: cd.relationship, hometown: cd.hometown
      cd.destroy
    end
  end

end
