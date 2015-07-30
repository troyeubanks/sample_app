require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
  	@user = users(:example)
  end

  test "unsuccessful edit" do
  	get edit_user_path(@user)
  	assert_template 'users/edit'
  	patch user_path(@user), user: { name: '', 
											  		email: "inv@lid",
											  		password: "something",
											  		password_confirmation: "something" }
    assert_template 'users/edit'
  end

  test "successful edit" do
  	get edit_user_path(@user)

  	name = @user.name
  	email = @user.email
  	patch user_path(@user), user: { name: name, 
											  		email: email,
											  		password: "",
											  		password_confirmation: "" }
    assert_redirected_to @user
    assert_not flash.empty?
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
