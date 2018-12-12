ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  fixtures :all
  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as user
    session[:user_id] = user.id
  end

  def helping user
    patch password_reset_path(user.reset_token),
      params: {email: user.email,
               user: {password: "foobaz",
                      password_confirmation: "barquux"}}
    assert_select "div#error_explanation"
    patch password_reset_path(user.reset_token),
      params: {email: user.email,
               user: {password: "",
                      password_confirmation: ""}}
    assert_select "div#error_explanation"
    patch password_reset_path(user.reset_token),
      params: {email: user.email,
               user: {password: "foobaz",
                      password_confirmation: "foobaz"}}
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
end
class ActionDispatch::IntegrationTest
  def log_in_as user, password: "password", remember_me: "1"
    post login_path, params: {session: {email: user.email,
                                        password: password,
                                        remember_me: remember_me}}
  end
end
