require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  def setup
    User.delete_all
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  def test_update
    first_name = 'Frank'

    put :update, profile: { first_name: first_name }
    assert_equal first_name, @user.reload.first_name
  end

end