class PostcodeChecksController < ApplicationController
  def create
    result = PostcodeChecker.new.call(Postcode.new(params["query"]))
    if result.success?
      message = if result.allowed?
                  "Good news, we can deliver"
                else
                  "Sorry our services are not available in your area"
                end
      redirect_to root_path, notice: message
    else
      redirect_to root_path, notice: result.error
    end
  end
end
