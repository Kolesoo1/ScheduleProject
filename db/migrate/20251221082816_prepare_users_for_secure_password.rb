class PrepareUsersForSecurePassword < ActiveRecord::Migration[8.1]
  def up
    rename_column :users, :encrypted_password,
                  :password_digest if column_exists?(:users, :encrypted_password)
  end

  def down
    rename_column :users, :password_digest,
                  :encrypted_password if column_exists?(:users, :password_digest)
  end
end