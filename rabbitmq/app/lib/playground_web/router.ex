defmodule PlaygroundWeb.Router do
  use Plug.Router

  plug Plug.Parsers, parsers: [:urlencoded]
  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/health" do
    send_resp(conn, 200, "alive")
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
