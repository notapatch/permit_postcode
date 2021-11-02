class PostcodeChecker
  def call(postcode)
    allow = AllowedPostcode.matching?(postcode)
    return Result.new(allowed: allow) if allow

    result = lookup_postcode(postcode)
    if result.success?
      allow = AllowedLsoa.matching?(result.lsoa.rpartition(" ")[0])
      return Result.new(allowed: allow)
    end

    Result.new(allowed: false, error: result.error)
  end

  class Result
    attr_reader :error

    def initialize(allowed:, error: nil)
      @allowed = allowed
      @error = error
    end

    def allowed?
      @allowed
    end

    def success?
      @error.blank?
    end
  end

  private

  def lookup_postcode(postcode)
    Clients::PostcodesIo.new.retrieve_postcode(postcode)
  end
end
