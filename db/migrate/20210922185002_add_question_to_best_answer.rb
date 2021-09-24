class AddQuestionToBestAnswer < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :best_answer_id, :integer, null: true
  end
end
