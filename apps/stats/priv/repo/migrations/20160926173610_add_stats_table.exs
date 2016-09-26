defmodule Stats.Repo.Migrations.AddStatsTable do
  use Ecto.Migration

  def change do
    create table(:stats) do
      add :sensor_id, :string, size: 50, null: false
      add :value, :integer, null: false

      timestamps(updated_at: false)
    end
  end
end
