class ProductsController < ApplicationController
  def show
    @product = Page.find(params[:id])
  end
end
