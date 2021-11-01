module PostcodeChecks
  class PostcodeChecksIndex
    def postcode_checks_index(postcode:)
      allow = AllowedPostcode.matching?(postcode)
      return Result.new(allowed: allow) if allow

      result = Clients::PostcodesIo.new.retrieve_postcode(postcode)
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
  end
end
