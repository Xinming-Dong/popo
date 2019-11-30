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
      Poison.decode!(resp.body)
      |>Map.get("results")
      |>Enum.at(0)
      |>Map.get("address_components")
      |>getNameList()
    else
      nil
    end
  end

  def getPOI(params, placetype, distance) do
    latlng = transform_param(params)
    if latlng != nil do
      query = []
      |>Keyword.put(:key, api_key())
      |>Keyword.put(:location, latlng)
      |>Keyword.put(:radius, distance)
      |>Keyword.put(:type, placetype)
      |>Keyword.put(:rankby, "prominence")
      |>URI.encode_query()
      resp = HTTPoison.get!("#{url1()}?#{query}")
      Poison.decode!(resp.body)|>getPOIName()
    end
  end

  def getPOI(params, distance) do
    data = placeTypes()
    |>Enum.flat_map(fn x -> getPOI(params, x, to_string(distance)) end)
    |> Enum.uniq()
    IO.inspect data
    if data|> Enum.count() < 3 do
      getPOI(params, distance + 100)
    else
      data
    end
  end

  def getPOI(params) do
    distance = 200
    Enum.concat(getPOI(params, distance), getLocation(params)) |> Enum.uniq()
  end

  def placeTypes() do
    ["point_of_interest", "restaurant"]
  end

  def getPOIName(data) do
    data
    |>Map.get("results")
    |>Enum.map(fn x -> Map.get(x, "name") end)
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

  def url1 do
    "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
  end
end
