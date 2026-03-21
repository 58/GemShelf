require "test_helper"

class UploadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in_as(@user)
    @upload = uploads(:one)
    @upload.file.attach(
      io: File.open(file_fixture("test.txt")),
      filename: "test.txt",
      content_type: "text/plain"
    )
  end

  # --- Authentication ---

  test "redirects to login when not authenticated" do
    sign_out
    get uploads_path
    assert_redirected_to root_path
  end

  # --- index ---

  test "index" do
    get uploads_path
    assert_response :success
    assert_select "h1", "すべてのファイル"
  end

  test "index shows only current user uploads" do
    other_upload = uploads(:two)
    other_upload.file.attach(io: StringIO.new("other"), filename: "other.txt", content_type: "text/plain")

    get uploads_path
    assert_response :success
    assert_select "table" do
      assert_select "tr td a[href=?]", upload_path(@upload)
    end
  end

  # --- new ---

  test "new" do
    get new_upload_path
    assert_response :success
    assert_select "h1", "ファイルをアップロード"
  end

  # --- create ---

  test "create with valid params" do
    assert_difference "Upload.count", 1 do
      post uploads_path, params: {
        upload: {
          title: "New file",
          description: "A test upload",
          file: fixture_file_upload("test.txt", "text/plain")
        }
      }
    end
    assert_redirected_to uploads_path
    follow_redirect!
    assert_select "div", /アップロードしました/
  end

  test "create without title still succeeds" do
    assert_difference "Upload.count", 1 do
      post uploads_path, params: {
        upload: {
          description: "no title",
          file: fixture_file_upload("test.txt", "text/plain")
        }
      }
    end
    assert_redirected_to uploads_path
  end

  # --- show ---

  test "show" do
    get upload_path(@upload)
    assert_response :success
  end

  test "show cannot access other user upload" do
    other_upload = uploads(:two)
    other_upload.file.attach(io: StringIO.new("other"), filename: "other.txt", content_type: "text/plain")

    get upload_path(other_upload)
    assert_response :not_found
  end

  # --- destroy ---

  test "destroy" do
    assert_difference "Upload.count", -1 do
      delete upload_path(@upload)
    end
    assert_redirected_to uploads_path
    follow_redirect!
    assert_select "div", /削除しました/
  end

  test "destroy cannot delete other user upload" do
    other_upload = uploads(:two)

    delete upload_path(other_upload)
    assert_response :not_found
  end
end
