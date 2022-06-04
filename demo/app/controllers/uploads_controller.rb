class UploadsController < ApplicationController
  def create
    @file = params.dig(:upload, :file)

    if @file
      render plain: "File: #{@file.original_filename}"
    else
      render plain: "No file"
    end
  end
end
