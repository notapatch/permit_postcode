class PostcodeChecksController < ApplicationController
  def create
    redirect_to root_path, notice: "Success, we allow SH24 1AA"
  end
end
