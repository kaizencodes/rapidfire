module Rapidfire
  class QuestionGroup < ActiveRecord::Base
    has_many  :questions
    has_one :rating, class_name: 'Rapidfire::Questions::Rating'
    validates :name, :presence => true

    after_create :initialize_rating

    if Rails::VERSION::MAJOR == 3
      attr_accessible :name
    end

    private

    def initialize_rating
      Rapidfire::Questions::Rating.create!(question_group_id: self.id, question_text: 'Értékelés', position: -1)
    end
  end
end
