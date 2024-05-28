class CreateCalendarEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :calendar_entries do |t|
      t.references :villa, null: false, foreign_key: true
      t.date :date
      t.integer :rate
      t.boolean :available

      t.timestamps
    end
  end
end
