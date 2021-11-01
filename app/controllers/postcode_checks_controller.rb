class PostcodeChecksController < ApplicationController
  def create
    result = PostcodeChecks::PostcodeChecksIndex
             .new
             .postcode_checks_index(postcode: params["query"])
    message = if result.allowed?
                "Good news, we can deliver"
              else
                "Sorry our services are not available in your area"
              end
    redirect_to root_path, notice: message
  end
end
