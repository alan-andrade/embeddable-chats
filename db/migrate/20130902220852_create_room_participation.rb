class CreateRoomParticipation < ActiveRecord::Migration
  def change
    create_table :room_participations do |t|
      t.references :user, index: true
      t.references :room, index: true
    end
  end
end
