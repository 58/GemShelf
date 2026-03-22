require "test_helper"

class UploadTest < ActiveSupport::TestCase
  setup do
    @upload = uploads(:one)
  end

  test "belongs to user" do
    assert_equal users(:one), @upload.user
  end

  test "image? returns true for image content type" do
    @upload.file.attach(io: StringIO.new("fake"), filename: "photo.png", content_type: "image/png")
    assert @upload.image?
  end

  test "image? returns false for non-image content type" do
    @upload.file.attach(io: StringIO.new("fake"), filename: "doc.pdf", content_type: "application/pdf")
    assert_not @upload.image?
  end

  test "video? returns true for video content type" do
    @upload.file.attach(io: StringIO.new("fake"), filename: "clip.mp4", content_type: "video/mp4")
    assert @upload.video?
  end

  test "video? returns false for non-video content type" do
    @upload.file.attach(io: StringIO.new("fake"), filename: "doc.txt", content_type: "text/plain")
    assert_not @upload.video?
  end

  test "pdf? returns true for pdf content type" do
    @upload.file.attach(io: StringIO.new("fake"), filename: "doc.pdf", content_type: "application/pdf")
    assert @upload.pdf?
  end

  test "pdf? returns false for non-pdf content type" do
    @upload.file.attach(io: StringIO.new("fake"), filename: "photo.png", content_type: "image/png")
    assert_not @upload.pdf?
  end

  test "image? returns false when no file attached" do
    assert_not @upload.image?
  end

  test "video? returns false when no file attached" do
    assert_not @upload.video?
  end

  test "pdf? returns false when no file attached" do
    assert_not @upload.pdf?
  end

  test "is destroyed when user is destroyed" do
    user = @upload.user
    assert_difference "Upload.count", -user.uploads.count do
      user.destroy
    end
  end
end
