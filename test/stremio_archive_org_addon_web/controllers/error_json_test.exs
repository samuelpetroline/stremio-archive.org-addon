defmodule StremioArchiveOrgAddonWeb.ErrorJSONTest do
  use StremioArchiveOrgAddonWeb.ConnCase, async: true

  test "renders 404" do
    assert StremioArchiveOrgAddonWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert StremioArchiveOrgAddonWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
