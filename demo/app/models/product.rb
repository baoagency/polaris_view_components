class Product
  include ActiveModel::Model

  attr_accessor :title, :status, :country, :selected_markets
end
