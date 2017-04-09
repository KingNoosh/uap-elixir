defmodule UserAgentParser do
  use Application

  @moduledoc """
  Documentation for UserAgentParser.
  """

  @patterns_path Path.join([File.cwd!, "deps", "uap-core", "regexes.yaml"])
  def patterns_path do
    @patterns_path
  end

  def start(_type, _args) do
    IO.inspect(UserAgentParser.Parser.parse("Mozilla/5.0 (Linux; U; Android 4.1.2; de-de; HTC_0P3Z11/1.12.161.3 Build/JZO54K) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30"))
    :ok
  end
end
