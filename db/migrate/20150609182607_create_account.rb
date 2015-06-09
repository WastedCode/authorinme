class CreateAccount < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
        t.string :username, unique: true, null: false, limit: 40, index: {case_sensitive: false, unique: true}
        t.string :email, unique: true, null: false, limit: 100, index: {case_sensitive: false, unique: true}
        t.string :password_digest, null: false
        t.timestamps
    end
  end
end
