class UpdateExistingMessageStatusToCompleted < ActiveRecord::Migration[8.1]
  def up
    Message.update_all(status: "completed")
  end

  def down
  end
end
