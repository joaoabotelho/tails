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
      user = insert(:personal_details).user

      response =
        conn
        |> assign_current_user(user)
        |> get(Routes.api_v1_user_path(conn, :show))
        |> json_response(:ok)

      assert response["personal_details"]
      assert response["personal_details"]["address"]
      assert response["email"]
      assert response["status"]
    end
  end

  describe "update user" do
    test "requires user log in", %{conn: conn} do
      insert(:user)
      conn = patch(conn, Routes.api_v1_user_path(conn, :update))
      assert json_response(conn, 403)
    end

    test "returns the user successfully", %{conn: conn} do
      user = insert(:personal_details).user

      params = %{
        "name" => "Randy Marsch",
        "age" => 10,
        "mobile_number" => "999999999",
        "emergency_contact" => "900900900",
        "title" => "mr",
        "address" => "Street 2 3",
        "address_line_2" => "",
        "city" => "South Park",
        "postal_code" => "30000",
        "state" => "Colorado"
      }

      response =
        conn
        |> assign_current_user(user)
        |> patch(Routes.api_v1_user_path(conn, :update), params)
        |> json_response(:ok)

      assert response["data"]["status"] == "ok"
    end
  end

  describe "complete user profile" do
    test "requires user log in", %{conn: conn} do
      insert(:user)
      conn = post(conn, Routes.api_v1_user_path(conn, :complete_profile, %{}))
      assert json_response(conn, 403)
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
