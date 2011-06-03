class Quiz < ActiveRecord::Base
  belongs_to :problem
  has_many :quiz_components, :dependent => :destroy
  has_many :components, :through => :quiz_components
end
