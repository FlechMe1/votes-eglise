require 'csv'

namespace :users do

  task :create_first_user => :environment do |t, args|
    u = User.create(firstname: 'Paul', lastname: 'Gruson', email: 'paul@lapepiniere.church', password: 'ChangeM3!', password_confirmation: 'ChangeM3!')

    u.add_role :admin
  end

  task :update_or_create_from_file => :environment do |t, args|
    file = './db/seeds/lapepiniere-2020.csv'

    puts "ENVIRONNEMENT : #{Rails.env}"


    csv_text = File.read(file)

    csv = CSV.parse(csv_text, headers: true, :col_sep => ",", :row_sep => :auto)

    existing_users = User.all.to_a
    new_user = 0
    updated_user = 0

    csv.each do |row|

      unless row['email'].blank?

        user = User.find_by(email: row['email'])

        if user.blank?
          puts "**** NOUVEL UTILISATEUR *****"
          user = User.new
          new_user = new_user + 1

          user.lastname = row['lastname']
          user.firstname = row['firstname']
          user.email = row['email']
          user.phone_1 = row['phone_1']
          user.phone_2 = row['phone_2']
          user.town = row['town']
          user.address_1 = row['address_1']
          user.address_2 = row['address_2']
          user.zipcode = row['zipcode']
          user.level = row['level']

          puts "*** CHECK IF USER FEEL GOOD"
          puts user.inspect

          user.invite!

          structure = Structure.first
          user.add_role :member, structure
        end

        # user.save
      end

    end

    puts "**** NOMBRE D'UTILISATEURS MIS A JOURS *****"
    puts updated_user

    puts "**** NOMBRE D'UTILISATEURS AJOUTES *****"
    puts new_user
  end

  task :generate_token => :environment do |t, args|

    puts "Generate Roken for each User"

    User.all.each do |u|
      if u.access_token.blank?
        puts "U : #{u.id} - Set Token"
        u.set_access_token
        u.save
      end
    end

  end
end