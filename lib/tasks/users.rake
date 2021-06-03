require 'csv'

namespace :users do

  task :create_first_user => :environment do |t, args|
    u = User.create(firstname: 'Paul', lastname: 'Gruson', email: 'paul@lapepiniere.church', password: 'ChangeM3!', password_confirmation: 'ChangeM3!')

    u.add_role :admin
  end

  task :update_or_create_from_file => :environment do |t, args|
    file = './db/seeds/epm-2021.csv'

    puts "ENVIRONNEMENT : #{Rails.env}"


    csv_text = File.read(file)

    csv = CSV.parse(csv_text, headers: true, :col_sep => ";", :row_sep => :auto)

    new_user = 0
    updated_user = 0

    structure = Structure.first

    puts structure.inspect

    puts csv.inspect


    csv.each do |row|

      puts row.inspect

      unless row['EMAIL'].blank?

        fullname = row['FULLNAME'].split(' ', 2)

        lastname = fullname.first
        firstname = fullname.last


        user = User.find_by(email: row['EMAIL'])

        if user
          puts "UPDATE USER #{user.fullname}"
          user.lastname = lastname
          user.firstname = firstname

          user.save

          user.add_role :member, structure

          updated_user = updated_user + 1

        else
          puts "CREATE USER #{row['FULLNAME']}"
          user = User.new
          user.lastname = lastname
          user.firstname = firstname
          user.email = row['EMAIL']

          user.invite!

          user.add_role :member, structure

          new_user = new_user + 1

        end

        # user.save
      end

    end

    puts "**** NOMBRE D'UTILISATEURS MIS A JOURS *****"
    puts updated_user

    puts "**** NOMBRE D'UTILISATEURS AJOUTES *****"
    puts new_user
  end

end