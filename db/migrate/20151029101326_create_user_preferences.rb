class CreateUserPreferences < ActiveRecord::Migration
  def change
    create_table :user_preferences do |t|
      t.string :optimizely_token

      t.timestamps null: false
    end
  end
end
