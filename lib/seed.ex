alias CraqQuestions.Question

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