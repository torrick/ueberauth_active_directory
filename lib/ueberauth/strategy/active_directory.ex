defmodule Ueberauth.Strategy.ActiveDirectory do
  use Ueberauth.Strategy, uid_field: :username

  alias Ueberauth.Strategy.ActiveDirectory.Ldap
  alias Ueberauth.Auth.Info
  alias Ueberauth.Auth.Extra

  def handle_callback!(conn) do
    {:ok, ldap_conn} = Ldap.connect
    case Ldap.authenticate(ldap_conn, conn.params["username"], conn.params["password"]) do
      {:ok, user} ->
        Ldap.close(ldap_conn)
        put_private(conn, :user, user)
      {:error, reason} -> set_errors!(conn, [error("login_failed", reason)])
    end
  end

  def handle_cleanup!(conn) do
    conn
    |> put_private(:user, nil)
  end

  def uid(conn) do
    conn.private.user['sAMAccountName'] |> List.first |> to_string
  end

  def info(conn) do
    user = conn.private.user

    %Info{
      name: Ldap.first_result(user['displayName']),
      first_name: Ldap.first_result(user['firstName']),
      last_name: Ldap.first_result(user['sn']),
      email: Ldap.first_result(user['mail']),
      nickname: Ldap.first_result(user['sAMAccountName'])
    }
  end

  def extra(conn) do
    %Extra{
      raw_info: %{
        ldap_user: conn.private.user,
        ldap_groups: conn.private.user['memberOf']
      }
    }
  end
end
