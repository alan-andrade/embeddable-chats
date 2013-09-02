class CreateRoom < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :subject
      t.references :chat, index: true
      t.boolean :is_open, default: true
    end
  end
end
