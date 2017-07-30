defmodule Chatty.Web.ChangesetView do
  use Chatty.Web, :view

  @doc """
  Traverses and translates changeset errors.

  See `Ecto.Changeset.traverse_errors/2` and
  `Chatty.Web.ErrorHelpers.translate_error/1` for more details.
  """
  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  def render("error.json-api", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON API object. So we just pass it forward.
    JaSerializer.EctoErrorSerializer.format(changeset)
  end
end
