require 'csv'

namespace :users do

  desc "Add Meeting to Campaign"

  task :update_or_create_from_file => :environment do |t, args|


    file = './db/seeds/pasteurs-2020.csv'


    csv_text = File.read(file)

    csv = CSV.parse(csv_text, headers: true, :col_sep => ",", :row_sep => :auto)

    existing_users = User.all.to_a
    new_user = 0
    updated_user = 0

    csv.each do |row|
      # Moulding.create!(row.to_hash)

      # puts row['ID']

      # user = User.find_or_create_by(email: row['email'], lastname: row['lastname'])

      user = User.find_by(id: 1000+row['ID'].to_i)



      if user.blank?
        puts "**** NOUVEAU PASTEUR *****"
        user = User.new
        new_user = new_user + 1
      else
        puts "**** MISE A JOURS PASTEUR *****"
        updated_user = updated_user + 1
      end

      user.lastname = row['lastname']
      user.firstname = row['firstname']
      user.email = row['email']
      user.phone_1 = row['phone_1']
      user.phone_2 = row['phone_2']
      user.town = row['town']
      user.zipcode = row['zipcode']
      user.level = row['level']

      user.save

      existing_users = existing_users - [user]

      puts user.inspect
    end

    puts "**** PASTEURS RESTANTS *****"
    disabled_user = 0
    existing_users.each do |user|
      puts "#{user.lastname} #{user.firstname} - #{user.email} : #{user.level}"
      user.disabled = true
      user.save
      disabled_user = disabled_user + 1
    end

    puts "**** NOMBRE DE PASTEURS MIS A JOURS *****"
    puts updated_user

    puts "**** NOMBRE DE PASTEURS AJOUTES *****"
    puts new_user

    puts "**** NOMBRE DE PASTEURS DESACTIVES *****"
    puts disabled_user
  end
end