defmodule TailsWeb.API.V1.PetControllerTest do
  use TailsWeb.ConnCase, async: true

  import Tails.Factory

  describe "Show pet" do
    test "requires user log in", %{conn: conn} do
      insert(:user)
      conn = get(conn, Routes.api_v1_pet_path(conn, :show, ""))
      assert json_response(conn, 403)
    end

    test "returns the pet successfully", %{conn: conn} do
      user = insert(:user)
      %{slug: slug} = insert(:pet, user: user)

      response =
        conn
        |> assign_current_user(user)
        |> get(Routes.api_v1_pet_path(conn, :show, slug))
        |> json_response(:ok)

      assert response["age"]
      assert response["breed"]
      assert response["microship_id"]
      assert response["slug"]
    end
  end

  describe "index pets" do
    test "requires user log in", %{conn: conn} do
      insert(:user)
      conn = get(conn, Routes.api_v1_pet_path(conn, :index))
      assert json_response(conn, 403)
    end

    test "returns current user's pets successfully", %{conn: conn} do
      user = insert(:user)
      %{slug: slug_1} = insert(:pet, user: user)
      %{slug: slug_2} = insert(:pet, user: user)

      response =
        conn
        |> assign_current_user(user)
        |> get(Routes.api_v1_pet_path(conn, :index))
        |> json_response(200)

      response_slugs =
        response
        |> Enum.map(&Map.get(&1, "slug"))
        |> Enum.uniq()

      assert Enum.all?([slug_1, slug_2], fn slug -> Enum.member?(response_slugs, slug) end)
    end
  end
end
