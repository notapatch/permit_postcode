class PostcodeChecksController < ApplicationController
  def create
    result = PostcodeChecker
             .new
             .call(postcode: Postcode.new(params["query"]))
    message = if result.allowed?
                "Good news, we can deliver"
              else
                "Sorry our services are not available in your area"
              end
    redirect_to root_path, notice: message
  end
end
