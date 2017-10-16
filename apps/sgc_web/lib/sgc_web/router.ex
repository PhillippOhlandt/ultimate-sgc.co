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

    scope "/profile/:id" do
      get "/", UserController, :show
      get "/posts", UserController, :posts
      get "/following", UserController, :following
      get "/followers", UserController, :followers
    end

    scope "/api", Api do
      pipe_through [:api]

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
      end
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", SGCWeb do
  #   pipe_through :api
  # end
end
