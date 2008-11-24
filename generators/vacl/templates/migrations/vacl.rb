class CreateVacls < ActiveRecord::Migration
  def self.up
    create_table :vacls do |t|
      t.string :name
      t.integer :creator_id
      t.boolean :default_vacl

      t.timestamps
    end

    add_index "vacls", :creator_id
  end

  def self.down
    drop_table :vacls
  end
end
