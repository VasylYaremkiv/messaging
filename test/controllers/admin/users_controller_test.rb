require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  def setup
    User.delete_all
    @admin = FactoryGirl.create(:user, :admin)
    sign_in @admin
    @user = FactoryGirl.create(:user)
  end

  def test_index_success_for_admin
    get :index
    assert_response :success
    assert_includes(assigns[:users], @user)
    assert_not_includes(assigns[:users], @admin)
  end

  def test_index_raise_error_for_not_admin
    sign_in @user
    assert_raises ActionController::RoutingError do
      get :index
    end
  end

  def test_edit
    get :edit, id: @user
    assert_response :success
    assert_equal(@user, assigns[:user])
  end

  def test_update
    first_name = 'Franky'
    last_name = 'Smitt'
    put :update, id: @user, user: { first_name: first_name, last_name: last_name, active: false }

    @user.reload
    assert_equal first_name, @user.first_name
    assert_equal last_name, @user.last_name
    refute @user.active?
    assert_redirected_to admin_users_path
  end

  def test_create_with_valid_params
    first_name = 'Franky'
    last_name = 'Smitt'
    username = 'test'
    assert_difference -> { User.count }, +1 do
      post :create, user: { username: username, first_name: first_name, last_name: last_name, active: true }
    end
    user = assigns(:user)
    assert_equal username, user.username
    assert_equal first_name, user.first_name
    assert_equal last_name, user.last_name
    assert user.active?
    assert_redirected_to admin_users_path
  end

  def test_create_with_same_username
    first_name = 'Franky'
    last_name = 'Smitt'
    assert_no_difference -> { User.count }  do
      post :create, user: { username: @user.username, first_name: first_name, last_name: last_name, active: true }
    end

    refute assigns(:user).valid?
  end

  def test_destroy
    assert_difference -> { User.count }, -1 do
      delete :destroy, id: @user
    end
    assert_redirected_to admin_users_path
  end

  def test_reset_password
    old_password = @user.encrypted_password
    post :reset_password, id: @user
    assert_not_equal old_password, @user.reload.encrypted_password
    assert_redirected_to admin_users_path
  end

end