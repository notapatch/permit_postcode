require "vcr"

VCR.configure do |c|
  # The directory where your cassettes will be saved
  c.cassette_library_dir = "spec/vcr"
  # Your HTTP request service. You can use whichever is your preference.
  c.hook_into :faraday
end
