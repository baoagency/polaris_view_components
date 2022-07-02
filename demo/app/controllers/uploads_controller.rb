class UploadsController < ApplicationController
  def create
    @file = params.dig(:upload, :file_one)
    @attachments = [
      params.dig(:upload, :attachment_one),
      params.dig(:upload, :attachment_two)
    ].compact

    if @file
      render plain: "File: #{@file.original_filename}"
    elsif @attachments.any?
      render plain: "Attachments (#{@attachments.size}): #{@attachments.join(", ")}"
    else
      render plain: "No files"
    end
  end
end
