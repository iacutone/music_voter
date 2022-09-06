defmodule MusicVoterWeb.Router do
  use MusicVoterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MusicVoterWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MusicVoterWeb do
    pipe_through :browser

    get "/", PageController, :index

    resources "/sessions", SessionController,
      only: [:new, :create], 
      singleton: true
  end
end
