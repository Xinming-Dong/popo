defmodule PopoWeb.PopoChannel do
  use PopoWeb, :channel

  alias Popo.Messages

  def join("popo:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (popo:lobby).
  def handle_in("shout", payload, socket) do
    IO.puts "popo channel check========="
    IO.inspect payload
    %{"id" => id, "message" => msg, "name" => name} = payload
    {int_id, _} = Integer.parse(id)
    IO.inspect int_id
    time = DateTime.utc_now()
    Messages.create_message(%{from: int_id, to: 2, content: msg, time: time})
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
