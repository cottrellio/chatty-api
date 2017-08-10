defmodule Chatty.Web.ChannelView do
  use Chatty.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :purpose]
end
