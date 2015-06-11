class CreateEntry < ActiveRecord::Migration
  def change
    create_table :entries do |t|
        t.references :account, null: false
        t.string :title, null: false, index: {case_sensitive: false}
        t.text :contents, null: false
        t.timestamps null: false
    end

    add_index(:entries, [:account_id, :title], unique: true)
  end
end
