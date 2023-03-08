defmodule CraqQuestions.SurveyTest do
  use ExUnit.Case
  doctest CraqQuestions.Survey

  alias CraqQuestions.{Question, Survey}

  describe "validate_answeres/1" do
    @questions [
      %Question{
        text: "What is the best way to play guitar?",
        options: [%{text: "by myself"}, %{text: "with lesson paid"}]
      },
      %Question{
        text: "What is your favorite guitar branch?",
        options: [%{text: "Taylor"}, %{text: "Gibson"}, %{text: "Seizi"}, %{text: "Martin"}]
      },
      %Question{
        text: "What is the grunge band the influenced the most?",
        options: [%{text: "Nirvana"}, %{text: "Alice in chains"}, %{text: "Pearl Jam"}]
      },
      %Question{
        text: "What is the best single below?",
        options: [
          %{text: "Everlong", completed_if_selected: true},
          %{text: "The pretender"},
          %{text: "Wheels"},
          %{text: "Best of you"}
        ]
      },
      %Question{
        text: "Why did you not choose Everlong?",
        options: [
          %{text: "It's not my preferred"},
          %{text: "I prefer Nirvana"}
        ]
      }
    ]

    test "returns :ok when answers are valid" do
      answers = %{q0: 1, q1: 2, q2: 2, q3: 1, q4: 1}

      assert :ok = Survey.validate_answers(@questions, answers)
    end

    test "returns an error if given an empty answer" do
      assert "was not answered" = Survey.validate_answers(@questions, %{})
    end

    test "returns an error when answer does not exist" do
      answers = %{q0: 4, q1: 2, q2: 2, q3: 1, q4: 1}

      assert [{:q0, "has an answer that is not on the list of valid answers"}] =
               Survey.validate_answers(@questions, answers)
    end

    test "returns an error when the previous response indicate the questions are complete" do
      answers = %{q0: 1, q1: 2, q2: 2, q3: 0, q4: 0}

      assert [
               {:q4,
                "was answered even though a previous response indicated that the questions were complete"}
             ] = Survey.validate_answers(@questions, answers)
    end

    test "returns a list of errors when questions are not answerd correctly" do
      answers = %{q0: 4, q2: 2, q3: 0, q4: 0}

      assert [
               {:q0, "has an answer that is not on the list of valid answers"},
               {:q1, "was not answered"},
               {:q4,
                "was answered even though a previous response indicated that the questions were complete"}
             ] = Survey.validate_answers(@questions, answers)
    end
  end
end
