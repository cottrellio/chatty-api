defmodule Chatty.Application do
  @moduledoc """
  The Chatty Application Service.

  The chatty system business domain lives in this application.

  Exposes API to clients such as the `Chatty.Web` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(Chatty.Repo, []),
    ], strategy: :one_for_one, name: Chatty.Supervisor)
  end
end
