class QuestionOption < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true

  has_attached_file :attachment_file
  validates_attachment_content_type :attachment_file, content_type: %w(attachment_file/jpg attachment_file/png)

end
