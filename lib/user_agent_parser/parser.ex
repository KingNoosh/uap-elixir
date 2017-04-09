defmodule UserAgentParser.Parser do
  @parsers UserAgentParser.Core.data

  def parse(user_agent) do
    os = parse_os(user_agent)
    device = parse_device(user_agent)
    parse_ua(user_agent, os, device)
  end

  defp parse_os(user_agent) do
    result = first_pattern_match(@parsers.os_parsers, user_agent)

    if result.match? do
      os_from_pattern_match(result.pattern, result.match)
    else
      %UserAgentParser.OperatingSystem{}
    end
  end

  defp parse_device(user_agent) do
    result = first_pattern_match(@parsers.device_parsers, user_agent)

    if result.match? do
      device_from_pattern_match(result.pattern, result.match)
    else
      %UserAgentParser.Device{}
    end
  end

  defp parse_ua(user_agent, os, device) do
    result = first_pattern_match(@parsers.user_agent_parsers, user_agent)

    if result.match? do
      user_agent_from_pattern_match(result.pattern, result.match, os, device)
    else
      %UserAgentParser.UserAgent{
        os: os,
        device: device
      }
    end
  end

  defp os_from_pattern_match(pattern, match) do
    os = if pattern["os_replacement"] do
      update_string(pattern["os_replacement"], match)
    else
      match |> Enum.at(1)
    end

    v1 = if pattern["os_v1_replacement"] do
      update_string(pattern["os_v1_replacement"], match)
    else
      match |> Enum.at(2)
    end

    v2 = if pattern["os_v2_replacement"] do
      update_string(pattern["os_v2_replacement"], match)
    else
      match |> Enum.at(3)
    end

    v3 = if pattern["os_v3_replacement"] do
      update_string(pattern["os_v3_replacement"], match)
    else
      match |> Enum.at(4)
    end

    v4 = if pattern["os_v4_replacement"] do
      update_string(pattern["os_v4_replacement"], match)
    else
      match |> Enum.at(5)
    end

    version = version_from_segments([v1, v2, v3, v4])
    %UserAgentParser.OperatingSystem{
      family: os,
      version: version
    }
  end

  defp device_from_pattern_match(pattern, match) do
    family = if pattern["device_replacement"] do
      update_string(pattern["device_replacement"], match)
    else
      match |> Enum.at(0) |> to_string
    end

    model = if pattern["model_replacement"] do
      update_string(pattern["model_replacement"], match)
    else
      match |> Enum.at(1)
    end

    brand = if pattern["brand_replacement"] do
      update_string(pattern["brand_replacement"], match)
    else
      match |> Enum.at(2)
    end

    %UserAgentParser.Device{
      family: family,
      brand: brand,
      model: model
    }
  end

  defp user_agent_from_pattern_match(pattern, match, os, device) do
    family = if pattern["family_replacement"] do
      update_string(pattern["os_replacement"], match)
    else
      match |> Enum.at(1)
    end

    v1 = if pattern["v1_replacement"] do
      update_string(pattern["v1_replacement"], match)
    else
      match |> Enum.at(2)
    end

    v2 = if pattern["v2_replacement"] do
      update_string(pattern["v2_replacement"], match)
    else
      match |> Enum.at(3)
    end

    v3 = if pattern["v3_replacement"] do
      update_string(pattern["v3_replacement"], match)
    else
      match |> Enum.at(4)
    end

    v4 = if pattern["v4_replacement"] do
      update_string(pattern["v4_replacement"], match)
    else
      match |> Enum.at(5)
    end

    version = version_from_segments([v1, v2, v3, v4])

    %UserAgentParser.UserAgent{
      family: family,
      version: version,
      os: os,
      device: device
    }
  end

  defp version_from_segments(args) do
    UserAgentParser.Version.new(args)
  end

  defp first_pattern_match(patterns, value) do
    pattern = patterns
    |> Enum.filter(&found?(&1, value))
    |> List.first
    result = %{
      :pattern => pattern,
      :match? => Kernel.is_map(pattern)
    }
    if result.match? do
      Map.put(result, :match, Regex.scan(pattern.regex, value) |> List.first)
    else
      result
    end
  end

  defp found?(pattern, value) do
    Regex.match?(pattern.regex, value)
  end

  defp update_string(string, match) do
    match
    |> Stream.with_index
    |> Enum.reduce(string, fn(str_idx, acc) ->
      {str, idx} = str_idx
      String.replace(acc, "$#{idx}", str)
    end)
  end
end
