class Contact < ApplicationRecord

  belongs_to :client  
  validates :email, uniqueness: { case_sensitive: false}, length: { in: 6..100 }
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates_format_of :mobile_number ,with: /\A(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})\z/
  validates_length_of :mobile_number,:in => 10..10, :on => :create

end