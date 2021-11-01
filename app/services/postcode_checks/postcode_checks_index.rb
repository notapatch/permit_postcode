module PostcodeChecks
  class PostcodeChecksIndex
    def postcode_checks_index(postcode:)
      normalized_postcode = postcode.delete(" ")
      postcode_allowed = AllowedPostcode.matching?(normalized_postcode)
      return Result.new(allowed: postcode_allowed) if postcode_allowed

      result = Clients::PostcodesIo.new.retrieve_postcode(normalized_postcode)
      if result.success?
        postcode_allowed = AllowedLsoa.matching?(result.lsoa.rpartition(" ")[0])
        return Result.new(allowed: postcode_allowed)
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
