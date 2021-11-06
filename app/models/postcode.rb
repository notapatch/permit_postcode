class Postcode
  include ActiveModel::Model

  def initialize(postcode)
    @postcode = postcode
  end

  def normalize
    @postcode.delete(" ").upcase
  end

  def to_s
    @postcode
  end
end
