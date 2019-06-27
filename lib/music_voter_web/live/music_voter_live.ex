defmodule MusicVoterWeb.MusicVoterLive do
  use Phoenix.LiveView
  alias MusicVoterWeb.MusicVoterView

  def render(assigns) do
    MusicVoterView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, assign(socket, :val, 0)}
  end

  def handle_event("inc", _value, socket) do
    {:noreply, update(socket, :val, &(&1 + 1))}
  end

  def handle_event("dec", _value, socket) do
    {:noreply, update(socket, :val, &(&1 - 1))}
  end
end
