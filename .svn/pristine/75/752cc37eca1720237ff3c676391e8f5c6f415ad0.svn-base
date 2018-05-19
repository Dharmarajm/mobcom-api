class Client < ApplicationRecord
	has_many :projects, dependent: :destroy
	has_many :contacts, dependent: :destroy
	accepts_nested_attributes_for :contacts, allow_destroy: true
   validates_uniqueness_of :name
   validates :name, uniqueness: { case_sensitive: false}

def self.file_generate
     CSV.generate do |csv|
      csv << ["first_name","last_name","mobile_number","email","employee_id","designation","ctc","date_of_birth","street","pincode","city","state","country"]
    end
  end

end
