class ChangeTokenDefaultsInMessages < ActiveRecord::Migration[8.1]
  def change
    change_column_default :messages, :token, from: nil, to: 0
    change_column_null :messages, :token, false, 0
  end
end
