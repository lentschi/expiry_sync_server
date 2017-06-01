class PasswordsController < Devise::PasswordsController

  def create
    # unset the share request flag if set (so not another email with text about sharing is sent):
    user = User.find_by_email(params[:user][:email])
    if !user.nil? and user.creating_to_accept_share
      user.creating_to_accept_share = false
      user.save
    end

    super
  end

  def edit
    super
    user = User.with_reset_password_token(params[:reset_password_token])
    if user.creating_to_accept_share
      render "edit_for_sharing"
    end
  end

  def update
    @user = User.find_by_reset_password_token(resource_params[:reset_password_token])
    super
    @user = User.find_by_id(@user.id)
    return if @user.reset_password_token.nil? # validation errors occurred

    @user.creating_to_accept_share = false
    @user.save
  end
end
