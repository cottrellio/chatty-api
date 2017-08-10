defmodule Chatty.Web.ErrorViewTest do
  use Chatty.Web.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json-api" do
    assert render(Chatty.Web.ErrorView, "404.json-api", []) ==
           %{"errors" => [%{status: 404, title: "Not Found"}], "jsonapi" => %{"version" => "1.0"}}
  end

  test "render 500.json" do
    assert render(Chatty.Web.ErrorView, "500.json", []) ==
           %{"errors" => [%{status: 500, title: "Internal Server Error"}], "jsonapi" => %{"version" => "1.0"}}
  end

  test "render any other" do
    assert render(Chatty.Web.ErrorView, "505.json", []) ==
           %{"errors" => [%{status: 500, title: "Internal Server Error"}], "jsonapi" => %{"version" => "1.0"}}
  end
end
