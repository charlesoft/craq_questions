defmodule CraqQuestions.Survey do
  @moduledoc """
  Module for handling the answers for the given questions
  """

  alias CraqQuestions.Question

  def validate_answers(_questions, answers) when answers == %{} do
    "was not answered"
  end

  def validate_answers(questions, answers) do
    questions = Enum.with_index(questions)
    errors = %{errors: []}

    result =
      Enum.reduce(questions, errors, fn {question, question_number}, acc ->
        answer_key = ("q" <> "#{question_number}") |> String.to_atom()

        if answer_value = Map.get(answers, answer_key) do
          acc
          |> validate_answer(question, answer_value, answer_key)
          |> valid_answer_if_terminal(questions, answers, question_number, answer_key)
        else
          Map.put(acc, :errors, acc.errors ++ [{answer_key, "was not answered"}])
        end
      end)

    if length(result.errors) > 0 do
      result.errors
    else
      :ok
    end
  end

  defp validate_answer(acc, %Question{options: options}, answer_value, answer_key) do
    options_with_index = Enum.with_index(options)

    if Enum.any?(options_with_index, fn {_option, index} -> index == answer_value end) do
      acc
    else
      Map.put(
        acc,
        :errors,
        acc.errors ++ [{answer_key, "has an answer that is not on the list of valid answers"}]
      )
    end
  end

  defp valid_answer_if_terminal(acc, questions, answers, question_number, answer_key) do
    previous_answer_key = ("q" <> "#{question_number - 1}") |> String.to_atom()
    previous_answer_value = Map.get(answers, previous_answer_key)

    with {%Question{options: options}, _index} <-
           Enum.find(questions, fn {_question, index} -> index == question_number - 1 end),
         options_with_index <- Enum.with_index(options),
         true <-
           Enum.any?(options_with_index, fn {option, index} ->
             Map.has_key?(option, :completed_if_selected) and option.completed_if_selected and
               index == previous_answer_value
           end) do
      Map.put(
        acc,
        :errors,
        acc.errors ++
          [
            {answer_key,
             "was answered even though a previous response indicated that the questions were complete"}
          ]
      )
    else
      _error ->
        acc
    end
  end
end
