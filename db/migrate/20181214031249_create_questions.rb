class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.belongs_to :user, index: true
      t.string :title
      t.text :description
      t.boolean :status
      t.integer :answer_id

      t.timestamps
    end
  end
end
