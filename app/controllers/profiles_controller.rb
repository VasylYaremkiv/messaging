class ProfilesController < ApplicationController

  def edit
    render
  end

  def update
    if current_user.update(profile_attributes)
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def profile_attributes
    profile_params = %w(first_name last_name)
    if params[:profile][:password].present? || params[:profile][:password_confirmation].present?
      profile_params += %w(password password_confirmation)
    end
    params.require(:profile).permit(profile_params)
  end

end
