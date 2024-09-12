class Users::SessionsController < Devise::SessionsController
  layout 'devise'
  def destroy
    super
  end

end
