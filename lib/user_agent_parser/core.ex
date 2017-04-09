defmodule UserAgentParser.Core do
  def data do
    Application.ensure_all_started(:yaml_elixir)
    load_patterns(UserAgentParser.patterns_path)
  end

  defp load_patterns(path) do
    yml = YamlElixir.read_from_file(path)

    user_agent_parsers = yml["user_agent_parsers"]
    |> Enum.reduce({}, &process_parsers/2)
    |> Tuple.to_list

    os_parsers = yml["os_parsers"]
    |> Enum.reduce({}, &process_parsers/2)
    |> Tuple.to_list

    device_parsers = yml["device_parsers"]
    |> Enum.reduce({}, &process_parsers/2)
    |> Tuple.to_list

    %{
      :user_agent_parsers => user_agent_parsers,
      :os_parsers => os_parsers,
      :device_parsers => device_parsers
    }
  end

  defp process_parsers(pattern, parsers) do
    updated_pattern = Map.put_new(
      pattern,
      :regex,
      Regex.compile!(
        pattern["regex"],
        Kernel.to_string(
          pattern["regex_flag"]
        )
      )
    )
    Tuple.append(parsers, updated_pattern)
  end
end
