require 'test_helper'

class MessagesControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  def setup
    User.delete_all
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  def test_index
    another_user = FactoryGirl.create(:user)
    inactive_user = FactoryGirl.create(:user, active: false)
    get :index
    assert_response :success
    contacts = assigns[:contacts]
    assert_includes(contacts, another_user)
    assert_not_includes(contacts, @user)
    assert_not_includes(contacts, inactive_user)
  end

end