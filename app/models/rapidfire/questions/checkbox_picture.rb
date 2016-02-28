module Rapidfire
  module Questions
    class CheckboxPicture < Rapidfire::Question
    validates :answer_options, :presence => true

    has_many :options, as: :attachable

      def validate_answer(answer)
        super(answer)

        if rules[:presence] == "1" || answer.answer_text.present?
          answer.answer_text.split(Rapidfire.answers_delimiter).each do |value|
            answer.errors.add(:answer_text, :invalid) unless options.include?(value)
          end
        end
      end
    end
  end
end
