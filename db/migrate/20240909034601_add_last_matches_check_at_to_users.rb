class AddLastMatchesCheckAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_matches_check_at, :datetime
  end
end
