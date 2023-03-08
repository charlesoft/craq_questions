defmodule CraqQuestions.Survey do
  @moduledoc """
  Module for handling the answers for the questions
  """

  alias CraqQuestions.Question

  @questions [
    {
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
        text: "What is the best single below",
        options: [
          %{text: "Everlong", completed_if_selected: true},
          %{text: "The pretender"},
          %{text: "Wheels"},
          %{text: "Best of you"}
        ]
      }
    }
  ]

  def validate_answers(answers) do
    questions = Enum.with_index(@questions)
    errors = %{errors: []}

    result =
      Enum.reduce(questions, errors, fn {question, question_number}, acc ->
        answer_key = ("q" <> "#{question_number}") |> String.to_atom()

        if answer_value = Map.get(answers, answer_key) do
          acc
          |> validate_answer(question, answer_value, answer_key)
          |> valid_answer_if_terminal(questions, question_number, answer_key)
        else
          acc[:errors] ++ [[answer_key, "was not answered"]]
        end
      end)

    if length(result[:errors]) > 0 do
      result[:errors]
    else
      :ok
    end
  end

  defp validate_answer(acc, %Question{options: options}, answer_value, answer_key) do
    options_with_index = Enum.with_index(options)

    if Enum.any?(options_with_index, fn {_option, index} -> index == answer_value end) do
      acc
    else
      acc[:errors] ++ [{answer_key, "has an answer that is not on the list of valid answers"}]
    end
  end

  defp valid_answer_if_terminal(acc, questions, question_number, answer_key) do
    {%Question{options: options}, _index} =
      Enum.find(questions, fn {_question, index} -> index == question_number - 1 end)

    if Enum.any?(options, fn option -> option.complete_if_selected end) do
      acc[:errors] ++
        [
          {answer_key,
           "was answered even though a previous response indicated that the questions were complete"}
        ]
    else
      acc
    end
  end
end
