class AllowedPostcode < ApplicationRecord
  def self.matching?(postcode)
    where(postcode: postcode.normalize).any?
  end
end
