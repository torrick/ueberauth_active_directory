defmodule Ueberauth.Strategy.ActiveDirectoryTest do
  use ExUnit.Case
  use Plug.Test

  @router SpecRouter.init([])

  test "request phase" do
    conn = :get
      |> conn("/auth/active_directory")
      |> SpecRouter.call(@router)
    assert conn.resp_body == "active directory request"
  end

  test "callback phase" do
    opts = %{
      username: "vagrant",
      password: "vagrant"
    }
    query = URI.encode_query(opts)

    conn = :get
      |> conn("/auth/active_directory/callback?#{query}")
      |> SpecRouter.call(@router)

    assert conn.resp_body == "active directory callback"
    auth = conn.assigns.ueberauth_auth
    assert auth.provider == :active_directory
    assert auth.strategy == Ueberauth.Strategy.ActiveDirectory
    assert auth.uid == opts.username

    info = auth.info
    assert info.name == 'Vagrant'
    assert info.email == nil

  end
end
