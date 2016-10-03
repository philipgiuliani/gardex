defmodule Stats.Stat do
  use Ecto.Schema

  schema "stats" do
    field :sensor_id, :string
    field :value, :float

    timestamps(updated_at: false)
  end
end
