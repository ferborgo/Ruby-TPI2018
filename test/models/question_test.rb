require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  test "should not save question without title" do
    question = Question.new
    assert_not question.save
  end

  test "should not delete the question" do
  	question = Question.find(1)
  	
  end
end
