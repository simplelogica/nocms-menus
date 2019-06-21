active_record_migration_class =
  if Rails::VERSION::MAJOR >= 5
    ActiveRecord::Migration[Rails::VERSION::MAJOR.to_f]
  else
    ActiveRecord::Migration
  end

class CreateProducts < active_record_migration_class
  def change
    create_table :products do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
