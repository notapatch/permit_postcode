class PostcodeChecker
  def call(postcode)
    allow = AllowedPostcode.matching?(postcode)
    return Result.new(allowed: allow) if allow

    result = lookup_postcode(postcode)
    if result.success?
      allow = AllowedLsoa.matching?(result.lsoa.rpartition(" ")[0])
      return Result.new(allowed: allow)
    end

    Result.new(allowed: false)
  end

  class Result
    def initialize(allowed:)
      @allowed = allowed
    end

    def allowed?
      @allowed
    end
  end

  private

  def lookup_postcode(postcode)
    Clients::PostcodesIo.new.retrieve_postcode(postcode)
  end
end
