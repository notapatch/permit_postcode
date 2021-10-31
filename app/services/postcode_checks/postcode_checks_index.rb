module PostcodeChecks
  class PostcodeChecksIndex
    def postcode_checks_index(postcode_query:)
      postcode_allowed = AllowedPostcode.matching?(postcode_query)
      Result.new(allowed: postcode_allowed)
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
