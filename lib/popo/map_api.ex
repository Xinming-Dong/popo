defmodule Popo.MapApi do

  def getLocation(user, users) do
    latlng = transform_param(user)
    if latlng != nil do
      query = []
      |>Keyword.put(:key, api_key())
      |>Keyword.put(:center, latlng)
      |>Keyword.put(:latlng, latlng)
      |>Keyword.put(:size, "600x300")
      |>Keyword.put(:zoom, "15")
      |>Keyword.put(:sensor, "false")
      |>Keyword.put(:markers, set_marker("red", latlng))
      |>URI.encode_query()
      resp = HTTPoison.get!("#{url()}?#{query}"<>users_markers(users))
	IO.inspect(resp)
      image = Base.encode64(resp.body)
    image
    else
      nil
    end
  end
  def set_marker(color,latlng) do
    color<>"|"<>latlng

  end
  def users_markers(users) do
   mks = Enum.map(users, fn x->"markers=green%7C"<>to_string(x.latitude)<>"%2C"<>to_string(x.longitude) end)
	|> Enum.join("&")
   if (users != nil and length(users) > 0) do
     "&"<>mks
   else
     ""
   end

  end


  def api_key do
    Application.get_env(:popo, :api_key)
  end

  def transform_param(user) do
    lat = user.latitude
    lon = user.longitude
    if lat != nil && lon != nil do
      "#{lat},#{lon}"
    else
      nil
    end
  end

  def url do
    "https://maps.googleapis.com/maps/api/staticmap"
  end

end
