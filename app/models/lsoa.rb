class Lsoa
  include ActiveModel::Model

  def initialize(lsoa)
    @lsoa = lsoa || ""
  end

  # lsoa is made out of a string and a number
  # Example: "Milton Keynes 014E"
  #   - we want the name but not the number
  # I can't find out what the name is actually
  # so chose the generic "name_part"
  def name_part
    @lsoa.rpartition(" ")[0]
  end

  def to_s
    @lsoa
  end
end
