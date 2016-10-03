defmodule StatsTest do
  use ExUnit.Case

  alias Stats.Stat
  alias Stats.Repo

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  describe "get_stats/1" do
    setup do
      %Stat{sensor_id: "moisture", value: 5.0} |> Repo.insert()
      %Stat{sensor_id: "temp", value: 5.0} |> Repo.insert()

      :ok
    end

    test "returns stats of the given sensor" do
      stats = Stats.get_stats("moisture")
      assert length(stats) == 1
    end

    test "returns state of a given date" do
      date = {2016,1,1}

      %Stat{sensor_id: "moisture", value: 5.0, inserted_at: Ecto.DateTime.from_erl({date, {0,0,0}})} |> Repo.insert()
      stats = Stats.get_stats("moisture", Date.from_erl!(date))
      assert length(stats) == 1
    end
  end
end
