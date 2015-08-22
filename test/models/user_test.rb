require 'test_helper'

class UserTest < ActiveSupport::TestCase

	def setup
		@user = User.new(name: "Test Modaniston", email: "email@email.com",
											password: "foobar", password_confirmation: "foobar")
	end

	test "should be valid" do
		assert @user.valid?
	end

	test "name should be present" do
		@user.name = '    '
		assert_not @user.valid?
	end

	test "email should be present" do
		@user.email = '        '
		assert_not @user.valid?
	end

	test "name should not be too long" do
		@user.name = "A" * 51
		assert_not @user.valid?
	end

	test "email should not be too long" do
		@user.email = "a" * 244 + "@example.com"
		assert_not @user.valid?
	end

	test "email validation should accept valid addresses" do
		valid_addresses = %w(user@example.com USER@foo.COM A_US-ER@foo.bar.org 	
												first.last@foo.jp alice+bob@baz.cn)
		
		valid_addresses.each do |ad|
			@user.email = ad
			assert @user.valid?, "#{ad.inspect} should be valid"
		end
	end

	test "email validation should reject invalid addresses" do
		invalid_addresses = %w(user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com)

		invalid_addresses.each do |ad|
			@user.email = ad
			assert_not @user.valid?, "#{ad.inspect} should be invalid"
		end
	end

	test "email should be unique" do
		duplicate_user = @user.dup
		duplicate_user.email = @user.email.upcase
		@user.save
		assert_not duplicate_user.valid?
	end

	test "password should be present (nonblank)" do
		@user.password = @user.password_confirmation = ' ' * 6
		assert_not @user.valid?
	end

	test "password should have a minimum length" do
		@user.password = @user.password_confirmation = 'a' * 5
		assert_not @user.valid?
	end

	test "email addresses should be saved as downcase" do
		mixed_case_email = "NotDoWnCASE@example.coM"
		@user.email = mixed_case_email
		@user.save
		assert_equal mixed_case_email.downcase, @user.reload.email
	end

	test "authenticated? should return false for a user with nil digest" do
		assert_not @user.authenticated?('')
	end

	test "associated microposts should be destroyed" do
		@user.save
		@user.microposts.create!(content: "Lorem ipsum")
		assert_difference "Micropost.count", -1 do
			@user.destroy
		end
	end

	test "should follow and unfollow a user" do
		example = users(:example)
		archer  = users(:archer)
		assert_not example.following?(archer)
		example.follow(archer)
		assert example.following?(archer)
		assert archer.followers.include?(example)
		example.unfollow(archer)
		assert_not example.following?(archer)
	end

	test "feed should have the right posts" do
		example = users(:example)
		archer = users(:archer)
		lana = users(:lana)

		lana.microposts.each do |post_following|
			assert example.feed.include?(post_following)
		end

		example.microposts.each do |post_self|
			assert example.feed.include?(post_self)
		end

		archer.microposts.each do |post_unfollowed|
			assert_not example.feed.include?(post_unfollowed)
		end
	end
end
