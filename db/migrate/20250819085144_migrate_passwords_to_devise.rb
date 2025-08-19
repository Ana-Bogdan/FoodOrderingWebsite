class MigratePasswordsToDevise < ActiveRecord::Migration[8.0]
  def up
    # This migration handles the transition from bcrypt to Devise
    # Since we can't decrypt bcrypt passwords, we'll need to reset them
    # Users will need to use password reset functionality
    
    # Remove the old password_digest column
    remove_column :users, :password_digest
  end

  def down
    # Add back the password_digest column if we need to rollback
    add_column :users, :password_digest, :string
  end
end
