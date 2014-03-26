class ProductsController < ApplicationController
  def show
    if params[:change_name]
      @different_name = Product.find(params[:id])
    else
      @product = Product.find(params[:id])
    end
  end
end
