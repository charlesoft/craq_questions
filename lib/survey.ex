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

    # First the iteration below will iterate through the questions and find the given answer for it.
    # If the question were answered, it will run some validations.
    result =
      Enum.reduce(questions, errors, fn {question, question_number}, acc ->
        answer_key = build_answer_key(question_number)

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
    previous_answer_key = build_answer_key(question_number - 1)
    previous_answer_value = Map.get(answers, previous_answer_key)

    # Here, it will find and iterate through the options of the previous questions to find if there
    # are any option with completed_if_selected as true already answered.
    with {%Question{options: options}, _index} <-
           Enum.find(questions, fn {_question, index} -> index == question_number - 1 end),
         options_with_index <- Enum.with_index(options),
         true <- Enum.any?(options_with_index, &has_terminal_answer?(&1, previous_answer_value)) do
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

  defp build_answer_key(question_number) do
    ("q" <> "#{question_number}") |> String.to_atom()
  end

  defp has_terminal_answer?({%{completed_if_selected: true}, index}, previous_answer_value) do
    index == previous_answer_value
  end

  defp has_terminal_answer?(_option, _previous_answer_value), do: false
end
