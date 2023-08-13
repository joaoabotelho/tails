defmodule TailsWeb.API.V1.UserControllerTest do
  use TailsWeb.ConnCase, async: true

  import Tails.Factory

  describe "Show user" do
    test "requires user log in", %{conn: conn} do
      insert(:user)
      conn = get(conn, Routes.api_v1_user_path(conn, :show))
      assert json_response(conn, 403)
    end

    test "returns the user successfully", %{conn: conn} do
      user = insert(:user)

      response =
        conn
        |> assign_current_user(user)
        |> get(Routes.api_v1_user_path(conn, :show))
        |> json_response(:ok)

      assert response["name"]
      assert response["email"]
      assert response["status"]
    end
  end

  describe "complete user profile" do
    test "requires user log in", %{conn: conn} do
      insert(:user)
      conn = post(conn, Routes.api_v1_user_path(conn, :complete_profile, %{}))
      assert json_response(conn, 403)
    end

    test "returns the user successfully", %{conn: conn} do
      user = insert(:incomplete_user)

      params = %{
        "name" => "John"
      }

      response =
        conn
        |> assign_current_user(user)
        |> post(Routes.api_v1_user_path(conn, :complete_profile), params)
        |> json_response(:ok)

      assert response == %{"data" => %{"status" => "ok"}}
    end

    test "returns errors with missing params", %{conn: conn} do
      user = insert(:incomplete_user)

      response =
        conn
        |> assign_current_user(user)
        |> post(Routes.api_v1_user_path(conn, :complete_profile), %{})
        |> json_response(422)

      assert errors = response["errors"]

      assert errors == %{
               "name" => ["can't be blank"]
             }
    end

    test "returns errors with user already active", %{conn: conn} do
      user = insert(:user)

      response =
        conn
        |> assign_current_user(user)
        |> post(Routes.api_v1_user_path(conn, :complete_profile), %{})
        |> json_response(422)

      assert response == %{"message" => "user already active"}
    end
  end
end
