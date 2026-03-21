class UploadsController < ApplicationController
  before_action :set_upload, only: %i[ show destroy ]

  def index
    @uploads = Current.user.uploads.with_attached_file.order(created_at: :desc)
  end

  def new
    @upload = Upload.new
  end

  def create
    @upload = Current.user.uploads.build(upload_params)
    if @upload.save
      redirect_to uploads_path, notice: "アップロードしました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def destroy
    @upload.destroy
    redirect_to uploads_path, notice: "削除しました。"
  end

  private

  def set_upload
    @upload = Current.user.uploads.find(params[:id])
  end

  def upload_params
    params.expect(upload: [ :title, :description, :file ])
  end
end
