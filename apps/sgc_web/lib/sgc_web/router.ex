defmodule SGCWeb.Router do
  use SGCWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug SGCWeb.Plugs.CurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :guest_required do
    plug SGCWeb.Plugs.RequireGuest
  end

  pipeline :user_required do
    plug SGCWeb.Plugs.RequireUser
  end

  scope "/", SGCWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/", SGCWeb do
    pipe_through [:browser, :guest_required]

    get "/login", SessionController, :new
    post "/login", SessionController, :create
  end

  scope "/", SGCWeb do
    pipe_through [:browser, :user_required]

    get "/logout", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", SGCWeb do
  #   pipe_through :api
  # end
end
