class VerifyCode < ActiveRecord::Base
  attr_accessible :code, :ip, :desc, :mac, :key
  attr_accessor :mac, :key
  validates :code, :ip, :presence => true

  before_validation :set_code
  def set_code
    if key.present? && mac.present?
      self.code = Digest::MD5.hexdigest("#{key}+#{mac}")
    end
  end

  def self.is_verify?(code, ip)
    self.where(:code => code, :ip => ip).present?
  end
end
