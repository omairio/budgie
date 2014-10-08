class AddPasswordDigestToUsers < ActiveRecord::Migration
	def change
		add_column :users, :password_digest, :string
		add_column :users, :remember_token, :string
		add_index :users, :remember_token
		rename_column :users, :name, :first_name
		add_column :users, :last_name, :string
	end
end
