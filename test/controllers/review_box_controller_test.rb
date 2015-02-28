require 'test_helper'

class ReviewBoxControllerTest < ActionController::TestCase
  test "should get review_box" do
    get :review_box
    assert_response :success
  end

  test "should get front" do
    get :front
    assert_response :success
  end

  test "should get back" do
    get :back
    assert_response :success
  end

  test "should get answer" do
    get :answer
    assert_response :success
  end

end
