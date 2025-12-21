class AddAuthenticationToUsers < ActiveRecord::Migration[7.0]
  def up
    change_table :users do |t|
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip
      t.string :role, default: 'student'
      t.boolean :active, default: true
    end

    # Только добавляем индексы, которых еще нет
    unless index_exists?(:users, :reset_password_token)
      add_index :users, :reset_password_token, unique: true
    end

    unless index_exists?(:users, :confirmation_token)
      add_index :users, :confirmation_token, unique: true
    end

    unless index_exists?(:users, :role)
      add_index :users, :role
    end
  end

  def down
    remove_index :users, :role, if_exists: true
    remove_index :users, :confirmation_token, if_exists: true
    remove_index :users, :reset_password_token, if_exists: true

    change_table :users do |t|
      t.remove :active, :role, :last_sign_in_ip, :current_sign_in_ip,
               :last_sign_in_at, :current_sign_in_at, :sign_in_count,
               :unconfirmed_email, :confirmation_sent_at, :confirmed_at,
               :confirmation_token, :remember_created_at,
               :reset_password_sent_at, :reset_password_token,
               :encrypted_password
    end
  end
end