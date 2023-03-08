# CraqQuestions

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `craq_questions` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:craq_questions, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/craq_questions>.

## Getting Started

Open the terminal and type the following command:

```
iex -S mix
```

You can go to the seed.ex file to copy and past the code to create and list the questions or you can create your own. Example:

```elixir
[
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
```

Now, create a hash in the following format to answer each one of the questions. Example:

```elixir
answers = %{q0: 1, q1: 2, q2: 2, q3: 1, q4: 1}
```

Use the Survey module to validate the answers:

```elixir
CraqQuestions.Survey(questions, answers)
```