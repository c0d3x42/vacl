class CreateVacl < ActiveRecord::Migration
  def self.up
    create_table :vacls do |t|
      t.string :name
      t.integer :creator_id
      t.boolean :default_vacl

      t.timestamps
    end
    add_index "vacls", :creator_id

    create_table :vacl_grants do |t|
      t.integer :vacl_id
      t.integer :vacl_permission_set_id
      t.integer :vacl_group_id
      t.string  :direction

      t.timestamps
    end

    create_table :vacl_groups do |t|
      t.integer :owner_id
      t.string :name

      t.timestamps
    end

    create_table :vacl_group_memberships do |t|
      t.integer :vacl_group_id
      t.integer :vacl_user_id

      t.timestamps
    end

    create_table :vacl_permissions do |t|
      t.string :name
      t.integer :creator_id

      t.timestamps
    end

    create_table :vacl_permission_collections do |t|
      t.integer :vacl_permission_id
      t.integer :vacl_permission_set_id

      t.timestamps
    end

    create_table :vacl_permission_sets do |t|
      t.integer :owner_id
      t.string :name

      t.timestamps
    end

    create_table :vacl_thing_owners do |t|
      t.integer :creator_id
      t.integer :vacl_id
      t.integer :ownable_id
      t.string :ownable_type

      t.timestamps
    end

    create_table :vacl_users do |t|
      t.string :login

      t.timestamps
    end


  end

  def self.down
    drop_table :vacls
    drop_table :vacl_grants
    drop_table :vacl_groups
    drop_table :vacl_group_memberships
    drop_table :vacl_permissions
    drop_table :vacl_permission_collections
    drop_table :vacl_permission_sets
    drop_table :vacl_thing_owners
    drop_table :vacl_users
  end
end
