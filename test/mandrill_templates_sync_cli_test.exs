defmodule MandrillTemplatesSyncCliTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  import MandrillTemplatesSync.Cli, only: [parse_args: 1, run: 1]

  test "should render help message on unknown arguments" do
    assert parse_args(["de", "hell", "going", "on"]) == :help
  end

  test "should render help message for --help and -h" do
    assert parse_args(["-h"]) == :help
    assert parse_args(["--help"]) == :help
    assert parse_args(["--help"]) == :help
    assert parse_args(["--help", "wat"]) == :help
    assert parse_args(["-h", "wat"]) == :help
  end

  test "should render help message if only one of source-key and destination-key options are provided" do
    assert parse_args(["--source-key", "KEY1"]) == :help
    assert parse_args(["--destination-key", "KEY1"]) == :help
  end

  test "should recognize source API and destination API keys" do
    assert parse_args(["--source-key", "KEY1", "--destination-key", "KEY2"]) == ["KEY1", "KEY2"]
  end

  test "should recognize one account synchronization options" do
    assert parse_args(["--account-key", "KEY", "--from-postfix", "staging", "--to-postfix", "production"]) 
      == ["KEY", "staging", "production"]
  end

  test "seeing help message" do
    fun = fn ->
      run([])
    end

    assert capture_io(fun) =~ ~r/Usage/
  end
end

