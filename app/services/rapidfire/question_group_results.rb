module Rapidfire
  class QuestionGroupResults < Rapidfire::BaseService
    attr_accessor :question_group
    attr_accessor :user

    # extracts question along with results
    # each entry will have the following:
    # 1. question type and question id
    # 2. question text
    # 3. if aggregatable, return each option with value
    # 4. else return an array of all the answers given
    def summary
      @question_group.questions.collect do |question|
        results =
          case question
          when Rapidfire::Questions::Select, Rapidfire::Questions::Radio,
            Rapidfire::Questions::Checkbox
            answers = question.answers.map(&:answer_text).map do |text|
              text.to_s.split(Rapidfire.answers_delimiter)
            end.flatten

            answers.inject(Hash.new(0)) { |total, e| total[e] += 1; total }
          when Rapidfire::Questions::Short, Rapidfire::Questions::Date,
            Rapidfire::Questions::Long, Rapidfire::Questions::Numeric
            question.answers.pluck(:answer_text)

          when  Rapidfire::Questions::Rating
            question.answers.map{|a| a.answer_text.to_i }.inject(0,:+).to_f / question.answers.count
          end

        QuestionResult.new(question: question, results: results)
      end
    end

    def detailed
      @question_group.questions.collect do |question|
        results =
          case question
          when Rapidfire::Questions::Select, Rapidfire::Questions::Radio,
            Rapidfire::Questions::Checkbox
            question.answers.map do |answer|
              [answer.answer_group.user.to_s, answer.answer_text.to_s.split(Rapidfire.answers_delimiter)]
            end
            # answers.inject(Hash.new(0)) { |total, e| total[e] += 1; total }
          when Rapidfire::Questions::Short, Rapidfire::Questions::Date,
            Rapidfire::Questions::Long, Rapidfire::Questions::Numeric, Rapidfire::Questions::Rating
            question.answers.map do |answer|
              [answer.answer_group.user.to_s, answer.answer_text]
            end
          end

        QuestionResult.new(question: question, results: results)
      end
    end

    def of_user
      @answer_group = AnswerGroup.find_by(user: @user, question_group: @question_group)
      @answer_group.answers.collect do |answer|
        results =
          case answer.question
          when Rapidfire::Questions::Select, Rapidfire::Questions::Radio,
            Rapidfire::Questions::Checkbox
            answer.answer_text.to_s.split(Rapidfire.answers_delimiter).flatten
          when Rapidfire::Questions::Short, Rapidfire::Questions::Date,
            Rapidfire::Questions::Long, Rapidfire::Questions::Numeric,
            Rapidfire::Questions::Rating
            answer.answer_text
          end
          QuestionResult.new(question: answer.question, results: results)
      end
    end
  end
end
