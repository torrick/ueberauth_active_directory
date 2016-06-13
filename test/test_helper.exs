defmodule SpecRouter do
  require Ueberauth
  use Plug.Router

  plug :fetch_query_params
  plug Ueberauth, base_path: "/auth"

  plug :match
  plug :dispatch

  get "/auth/active_directory", do: send_resp(conn, 200, "active directory request")
  get "/auth/active_directory_with_options" do
    send_resp(conn, 200, "active directory with options request")
  end

  get "/auth/active_directory/callback", do: send_resp(conn, 200, "active directory callback")
  get "/auth/active_directory_with_options/callback" do
    send_resp(conn, 200, "active directory with options callback")
  end
end

ExUnit.start()
