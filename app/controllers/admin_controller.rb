class AdminController < ApplicationController
  def index
    render file: '/admin/index.html'
  end
end
