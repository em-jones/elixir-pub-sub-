defmodule Repo.Mongo do
  def add(name) do

    Mongo.insert_one(
      :mongodb,
      "activity",
      %{name: name}
    )
  end
end
