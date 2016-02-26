module Rapidfire
  module Exports
    class QuestionResultExporter < Rapidfire::BaseService
      attr_accessor :question_group

      def detailed
        CSV.generate do |csv|
          csv << ['Question', 'User', 'Answer']

          @question_group.questions.collect do |question|
            case question
            when Rapidfire::Questions::Select, Rapidfire::Questions::Radio,
              Rapidfire::Questions::Checkbox
              question.answers.map do |answer|
                csv << [question.question_text, answer.answer_group.user.to_s, answer.answer_text.to_s.split(Rapidfire.answers_delimiter)]
              end
              # answers.inject(Hash.new(0)) { |total, e| total[e] += 1; total }
            when Rapidfire::Questions::Short, Rapidfire::Questions::Date,
              Rapidfire::Questions::Long, Rapidfire::Questions::Numeric, Rapidfire::Questions::Rating
              question.answers.map do |answer|
                [answer.answer_group.user.to_s, answer.answer_text]
                csv << [question.question_text, answer.answer_group.user.to_s, answer.answer_text]
              end
            end
          end
        end
      end
    end
  end
end
