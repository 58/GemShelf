class Upload < ApplicationRecord
  belongs_to :user
  has_one_attached :file

  def image?
    file.attached? && file.content_type.start_with?("image/")
  end

  def video?
    file.attached? && file.content_type.start_with?("video/")
  end

  def pdf?
    file.attached? && file.content_type == "application/pdf"
  end
end
