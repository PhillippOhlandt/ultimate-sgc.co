defmodule SGC.Auth.Login do
  import Ecto.Changeset
  use Ecto.Schema

  embedded_schema do
    field :username, :string
    field :password, :string
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:username, :password])
    |> validate_length(:username, min: 3)
    |> validate_length(:password, min: 4, max: 25)
  end
end
