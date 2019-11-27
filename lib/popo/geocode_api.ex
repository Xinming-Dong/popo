defmodule Popo.GeocodeApi do

  def getLocation(params) do
    latlng = transform_param(params)
    if latlng != nil do
      query = []
      |>Keyword.put(:key, api_key())
      |>Keyword.put(:latlng, latlng)
      |>Keyword.put(:location_type, "ROOFTOP")
      |>URI.encode_query()
      resp = HTTPoison.get!("#{url()}?#{query}")
      data = Poison.decode!(resp.body)
      |>Map.get("results")
      |>Enum.at(0)
      |>Map.get("address_components")
      |>getNameList()
      %{locations: data}
    else
      nil
    end
  end

  def getNameList(address) do
    address
    |> Enum.filter(fn x -> !isExcludeTypes?(Map.get(x, "types")) end)
    |>Enum.map(fn x -> Map.get(x, "long_name") end)
  end

  def isExcludeTypes?(e) do
    Enum.member?(e, "street_number") ||
    Enum.member?(e, "country")||
    Enum.member?(e, "postal_code")
  end

  def api_key do
    Application.get_env(:popo, :api_key)
  end

  def transform_param(params) do
    lat = Map.get(params, :latitude)
    lon = Map.get(params, :longitude)
    if lat != nil && lon != nil do
      "#{lat},#{lon}"
    else
      nil
    end
  end

  def url do
    "https://maps.googleapis.com/maps/api/geocode/json"
  end
end
