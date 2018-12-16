class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.belongs_to :question, index: true
      t.belongs_to :user, index: true
      t.text :content

      t.timestamps
    end
  end
end
