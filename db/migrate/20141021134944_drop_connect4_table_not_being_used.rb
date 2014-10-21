class DropConnect4TableNotBeingUsed < ActiveRecord::Migration
  def change
  	drop_table :connect_4_rounds
  end
end
