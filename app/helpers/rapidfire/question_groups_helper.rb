module Rapidfire::QuestionGroupsHelper
  def quiz_filled_out?(quiz, user)
    !(Rapidfire::AnswerGroup.find_by(user: user, question_group: quiz).nil?)
  end
end
