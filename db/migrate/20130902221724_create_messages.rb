class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :room, index: true
      t.references :sender, index: true
      t.string :body, default: ''
    end
  end
end
