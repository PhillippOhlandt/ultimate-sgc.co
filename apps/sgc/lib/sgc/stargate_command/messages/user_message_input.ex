defmodule SGC.StargateCommand.Messages.UserMessageInput do
  import Ecto.Changeset
  use Ecto.Schema
  alias Ecto.Changeset
  alias Plug.Upload

  @primary_key false
  embedded_schema do
    field :text, :string, default: ""
    field :image, :any, virtual: true
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:text, :image])
    |> validate_text_is_set_if_image_is_unset()
    |> validate_image()
  end

  def validate_text_is_set_if_image_is_unset(%Changeset{changes: %{text: text, image: _}} = cs) when text in ["", nil], do: cs
  def validate_text_is_set_if_image_is_unset(%Changeset{changes: %{image: _}} = cs), do: cs
  def validate_text_is_set_if_image_is_unset(%Changeset{changes: %{text: text}} = cs) when text in ["", nil] do
    add_error(cs, :text, "can't be blank", [validation: :required])
  end
  def validate_text_is_set_if_image_is_unset(%Changeset{changes: %{text: _}} = cs), do: cs
  def validate_text_is_set_if_image_is_unset(%Changeset{changes: %{}} = cs) do
    add_error(cs, :text, "can't be blank", [validation: :required])
  end

  def validate_image(%Changeset{changes: %{image: %Upload{content_type: ct}}} = cs)
      when ct in ["image/jpeg", "image/png", "image/gif"], do: cs
  def validate_image(%Changeset{changes: %{image: %Upload{}}} = cs) do
    add_error(cs, :image, "must be a JPEG, PNG or GIF", [validation: :image_content_type])
  end
  def validate_image(%Changeset{changes: %{image: nil}} = cs), do: cs
  def validate_image(%Changeset{changes: %{image: _}} = cs) do
    add_error(cs, :image, "must be a file", [validation: :image])
  end
  def validate_image(%Changeset{changes: %{}} = cs), do: cs

  def request_data(%__MODULE__{text: text, image: nil}) do
    [{"text", text}]
  end
  def request_data(%__MODULE__{text: text, image: %Upload{} = image}) do
    [
      {"text", text},
      {:file, image.path,
        {"form-data", [
          name: "image",
          filename: image.filename
        ]},
        ["content-type": image.content_type]
      }
    ]
  end
end
