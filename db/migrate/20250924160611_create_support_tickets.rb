class CreateSupportTickets < ActiveRecord::Migration[8.0]
  def change
    create_table :support_tickets do |t|
      t.references :order, foreign_key: true, index: true
      t.references :user, foreign_key: true, index: true
      t.string :subject
      t.text :body
      t.string :status, default: "open", null: false
      t.timestamps
    end
  end
end
