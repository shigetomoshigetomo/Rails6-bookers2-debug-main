require "test_helper"

class GroupPostsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get group_posts_show_url
    assert_response :success
  end

  test "should get create" do
    get group_posts_create_url
    assert_response :success
  end

  test "should get destroy" do
    get group_posts_destroy_url
    assert_response :success
  end
end
