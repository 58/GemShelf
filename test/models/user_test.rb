require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "requires unique email_address at database level" do
    existing = users(:one)
    user = User.new(email_address: existing.email_address, password: "password")
    assert_raises(ActiveRecord::RecordNotUnique) { user.save!(validate: false) }
  end

  test "has many sessions" do
    user = users(:one)
    session = user.sessions.create!
    assert_includes user.sessions, session
  end

  test "has many uploads" do
    user = users(:one)
    assert_includes user.uploads, uploads(:one)
  end

  test "destroys sessions when destroyed" do
    user = users(:one)
    user.sessions.create!
    assert_difference "Session.count", -user.sessions.count do
      user.destroy
    end
  end
end
