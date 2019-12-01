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
       only: [:new, :create, :show, :index, :edit, :update]
    resources "/profiles", ProfileController
    resources "/posts", PostController
    resources "/messages", MessageController
    resources "/friends", FriendController
    
    get "/posts/:id/file", PostController, :file
    get "/profiles/:id/file", ProfileController, :file

    get "/message/chat", MessageController, :chat
    get "/message/nearby_chat", MessageController, :nearby_chat
  end

  # Other scopes may use custom stacks.
  # scope "/api", PopoWeb do
  #   pipe_through :api
  # end
end
