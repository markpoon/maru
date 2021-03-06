defmodule Maru.ResponseTest do
  use ExUnit.Case, async: true

  test "string response" do
    resp = "ok"
    assert "text/plain" == Maru.Response.content_type(resp)
    assert "ok" == Maru.Response.resp_body(resp)
  end

  test "map response" do
    resp = %{success: "ok"}
    assert "application/json" == Maru.Response.content_type(resp)
    assert ~s[{"success":"ok"}] == Maru.Response.resp_body(resp)
  end

  test "list response" do
    resp = [1, 2, 3]
    assert "application/json" == Maru.Response.content_type(resp)
    assert "[1,2,3]" == Maru.Response.resp_body(resp)
  end

  test "any response" do
    resp = :atom
    assert "text/plain" == Maru.Response.content_type(resp)
    assert "atom" == Maru.Response.resp_body(resp)
  end

  test "custom response" do
    defmodule User do
      defstruct name: nil, age: nil, password: nil
      def hehe, do: "hehe"
    end

    defimpl Maru.Response, for: User do
      def content_type(_) do
        "application/json"
      end

      def resp_body(user) do
        %{name: user.name} |> Poison.encode!
      end
    end

    resp = struct User, %{name: "falood", age: 25, password: "123456"}
    assert "application/json" == Maru.Response.content_type(resp)
    assert ~s[{"name":"falood"}] == Maru.Response.resp_body(resp)
  end
end
