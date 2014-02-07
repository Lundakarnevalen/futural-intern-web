namespace :db do
  desc "Insert admin"
  task populate: :environment do
    admin = User.create!(
                 email: "lars.nystrom@lundakarnevalen.se",
                 password: "passpass",
                 password_confirmation: "passpass")
    admin.roles = [Role.first]
    admin.save!
  end
end
