class VerifyCode < ActiveRecord::Base
  attr_accessible :code, :desc, :mac, :key
  attr_accessor :mac, :key
  validates :code, :presence => true

  before_validation :set_code
  def set_code
    if key.present? && mac.present?
      self.code = Digest::MD5.hexdigest("#{key}+#{mac}")
    end
  end

  def self.is_verify?(code)
    self.where(:code => code).present?
  end
end
