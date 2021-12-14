class SuggestionsController < ApplicationController
  def index
    @query = params[:q]
    @options = [
      {value: "rustic", label: "Rustic"},
      {value: "antique", label: "Antique"},
      {value: "vinyl", label: "Vinyl"},
      {value: "vintage", label: "Vintage"},
      {value: "refurbished", label: "Refurbished"}
    ]
    if @query.present?
      @options.select! { |option| option[:label].match(@query) }
    end

    render layout: false
  end
end
