defmodule Chatty.Web.ErrorView do
  use Chatty.Web, :view
  use JaSerializer.PhoenixView

  def render("401.json-api", assigns) do
    data = Map.get(assigns, :data, %{})

    %{title: "Unauthorized", status: 401}
    |> Map.merge(data)
    |> JaSerializer.ErrorSerializer.format
  end

  def render("403.json-api", assigns) do
    data = Map.get(assigns, :data, %{})

    %{title: "Forbidden", status: 403}
    |> Map.merge(data)
    |> JaSerializer.ErrorSerializer.format
  end

  def render("404.json-api", assigns) do
    data = Map.get(assigns, :data, %{})

    %{title: "Not Found", status: 404}
    |> Map.merge(data)
    |> JaSerializer.ErrorSerializer.format
  end

  def render("422.json-api", assigns) do
    data = Map.get(assigns, :data, %{})

    %{title: "Unprcessable Entity", status: 422}
    |> Map.merge(data)
    |> JaSerializer.ErrorSerializer.format
  end

  def render("500.json-api", assigns) do
    data = Map.get(assigns, :data, %{})

    %{title: "Internal Server Error", status: 500}
    |> Map.merge(data)
    |> JaSerializer.ErrorSerializer.format
  end

  # # In case no render clause matches or no
  # # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json-api", assigns
  end
end
