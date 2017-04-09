defmodule UserAgentParser.Version do
  defstruct major: nil, minor: nil, patch: nil, patch_minor: nil

  def new(args) do
    %UserAgentParser.Version{
      major: args |> Enum.at(0),
      minor: args |> Enum.at(1),
      patch: args |> Enum.at(2),
      patch_minor: args |> Enum.at(3)
    }
  end
end
