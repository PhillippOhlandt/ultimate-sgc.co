defmodule SGCWeb.Router do
  use SGCWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug SGCWeb.Plugs.CurrentUser
    plug SGCWeb.Plugs.UpdateCurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug SGCWeb.Plugs.CurrentUser
  end

  pipeline :guest_required do
    plug SGCWeb.Plugs.RequireGuest
  end

  pipeline :user_required do
    plug SGCWeb.Plugs.RequireUser
  end

  pipeline :user_required_api do
    plug SGCWeb.Plugs.RequireUser, format: :json
  end

  ## Browser - Everyone ##

  scope "/", SGCWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  ## Browser - Guest required ##

  scope "/", SGCWeb do
    pipe_through [:browser, :guest_required]

    get "/login", SessionController, :new
    post "/login", SessionController, :create
  end

  ## Browser - User required ##

  scope "/", SGCWeb do
    pipe_through [:browser, :user_required]

    get "/logout", SessionController, :delete

    scope "/profile/:id" do
      get "/", UserController, :show
    end
  end

  ## API - User required ##

  scope "/", SGCWeb do
    pipe_through [:api, :user_required_api]

    scope "/profile/:id" do
      get "/posts", UserController, :posts
      get "/following", UserController, :following
      get "/followers", UserController, :followers
    end

    scope "/api", Api do
      scope "/notifications" do
        get "/", NotificationController, :index
        get "/:id/mark_read", NotificationController, :mark_read
        get "/mark_all_read", NotificationController, :mark_all_read
      end

      scope "/discussions" do
        get "/", DiscussionController, :index
        get "/mark_all_read", DiscussionController, :mark_all_read
      end

      scope "/messages" do
        get "/", MessageController, :index
        get "/mark_all_read", MessageController, :mark_all_read
        get "/:id", MessageController, :show
        post "/:id", MessageController, :store
      end
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", SGCWeb do
  #   pipe_through :api
  # end
end
