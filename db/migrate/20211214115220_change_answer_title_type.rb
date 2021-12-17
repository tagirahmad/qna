class ChangeAnswerTitleType < ActiveRecord::Migration[6.1]
  def change
    change_column(:answers, :title, :text)
  end
end
