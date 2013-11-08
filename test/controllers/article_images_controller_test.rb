require 'test_helper'

class ArticleImagesControllerTest < ActionController::TestCase
  setup do
    @article_image = article_images(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:article_images)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create article_image" do
    assert_difference('ArticleImage.count') do
      post :create, article_image: { article_id: @article_image.article_id, article_source_id: @article_image.article_source_id, creator_id: @article_image.creator_id, image_data: @article_image.image_data, source_url: @article_image.source_url }
    end

    assert_redirected_to article_image_path(assigns(:article_image))
  end

  test "should show article_image" do
    get :show, id: @article_image
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @article_image
    assert_response :success
  end

  test "should update article_image" do
    patch :update, id: @article_image, article_image: { article_id: @article_image.article_id, article_source_id: @article_image.article_source_id, creator_id: @article_image.creator_id, image_data: @article_image.image_data, source_url: @article_image.source_url }
    assert_redirected_to article_image_path(assigns(:article_image))
  end

  test "should destroy article_image" do
    assert_difference('ArticleImage.count', -1) do
      delete :destroy, id: @article_image
    end

    assert_redirected_to article_images_path
  end
end
