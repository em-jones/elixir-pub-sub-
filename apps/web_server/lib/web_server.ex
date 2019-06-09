defmodule WebServer do
  import Plug.Conn

  @moduledoc """
  Documentation for WebServer.
  """

  @doc """
  Hello world.

  ## Examples

      iex> WebServer.hello()
      :world

  """
  def init(options), do: options

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello World!\n")
  end
end
