class AllowedPostcode < ApplicationRecord
  def self.matching?(postcode)
    where(postcode: postcode.delete(" ").upcase).any?
  end
end
