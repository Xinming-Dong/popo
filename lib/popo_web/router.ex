defmodule PopoWeb.Router do
  use PopoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PopoWeb.Plugs.FetchCurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PopoWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/sessions", SessionController, 
      only: [:new, :create, :delete], singleton: true
    resources "/users", UserController,
       only: [:new, :create, :show, :index]
  end

  # Other scopes may use custom stacks.
  # scope "/api", PopoWeb do
  #   pipe_through :api
  # end
end
