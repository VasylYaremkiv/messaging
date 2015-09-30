require 'test_helper'

class ContactsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  def setup
    User.delete_all
    @user = FactoryGirl.create(:user)
    sign_in @user
    @receiver = FactoryGirl.create(:user)
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

  def test_create_message
    message_text = 'Test'

    assert_no_difference -> { @user.reload.unread_message_count }  do
      assert_difference -> { @receiver.reload.unread_message_count }, +1 do
        assert_difference -> { Message.count }, +1 do
          post :create_message, id: @receiver, message: { message: message_text }
        end
      end
    end

    message = assigns[:message]
    refute message.read?
    assert_equal @user, message.sender
    assert_equal @receiver, message.receiver
  end

  def test_show
    message_from_user = FactoryGirl.create(:message, sender: @user, receiver: @receiver)
    messages_to_user = FactoryGirl.create_list(:message, 3, sender: @receiver, receiver: @user)
    assert_equal 3, @user.reload.unread_message_count
    assert_equal 1, @receiver.reload.unread_message_count

    get :show, id: @receiver

    refute message_from_user.reload.read?
    assert_equal 1, @receiver.reload.unread_message_count

    message = messages_to_user.first
    assert message.reload.read?
    assert_equal 0, @user.reload.unread_message_count
  end

  def test_amount_unread_message
    FactoryGirl.create_list(:message, 3, sender: @receiver, receiver: @user)

    get :amount_unread_message

    result = JSON.parse response.body

    assert 3, result['unread_message_count']
  end

end