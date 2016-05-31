class Template < ActiveRecord::Base
  belongs_to :user
  
  METHODS_OF_COM = ["Phone", "Email", "Text", "Letter", "Postcard", "Face To Face", "Other"]
  
  validates :name, :task_description, presence: true
  validates :method_of_communication, inclusion: { in: METHODS_OF_COM }
end
