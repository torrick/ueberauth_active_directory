defmodule Ueberauth.Strategy.ActiveDirectory.LdapTest do
  use ExUnit.Case
  alias Ueberauth.Strategy.ActiveDirectory.Ldap

  ## All tests require vagrant box to be started first

  test "Successful authenticate/3" do
    opts = %{
      username: "vagrant",
      password: "vagrant"
    }
    {:ok, conn} = Ldap.connect
    {:ok, user} = Ldap.authenticate(conn, opts.username, opts.password)
    assert user['sAMAccountName'] == ['vagrant']
    assert user['name'] == ['vagrant']
    Ldap.close(conn)
  end

  test "Unsuccessful authenticate/3 with good username" do
    opts = %{
      username: "vagrant",
      password: "badpassword"
    }
    {:ok, conn} = Ldap.connect
    assert {:error, :invalidCredentials} == Ldap.authenticate(conn, opts.username, opts.password)
    Ldap.close(conn)
  end

  test "Unsuccessful authenticate/3 with bad username" do
    opts = %{
      username: "missinguser",
      password: "badpassword"
    }
    {:ok, conn} = Ldap.connect
    assert {:error, "Failed to verify credentials: User not found"} == Ldap.authenticate(conn, opts.username, opts.password)
    Ldap.close(conn)
  end
end
