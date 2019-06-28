defmodule MusicVoterWeb.Router do
  use MusicVoterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MusicVoterWeb do
    pipe_through :browser

    get "/", PageController, :index
  end
end
