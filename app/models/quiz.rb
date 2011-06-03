class Quiz < ActiveRecord::Base
  attr_reader :component_tokens

  belongs_to :problem
  has_many :quiz_components, :dependent => :destroy
  has_many :components, :through => :quiz_components

  def component_tokens=(ids)
    self.component_ids = ids.split(",")
  end
end
