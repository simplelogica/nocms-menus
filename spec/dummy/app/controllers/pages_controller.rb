class PagesController < ApplicationController

  def show
    @page = Page.where(name: params[:path].gsub('-', ' ')).first
  end
end
