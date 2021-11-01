class AllowedLsoa < ApplicationRecord
  def self.matching?(lsoa)
    where(lsoa: lsoa.strip.downcase).any?
  end
end
