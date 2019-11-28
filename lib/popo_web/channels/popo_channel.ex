defmodule PopoWeb.PopoChannel do
  use PopoWeb, :channel

  alias Popo.Messages

  intercept ["shout"]

  def join("popo:lobby", payload, socket) do
    if authorized?(payload) do
      IO.puts ">>>>>>>>>>>join channel"
      # PopoWeb.Endpoint.subscribe("popo:" <> _id)
      IO.inspect payload["id"]
      IO.inspect payload
      socket = socket
        |> assign(:user, payload["id"])
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
    IO.inspect socket
    IO.inspect payload
    %{"id" => id, "message" => msg, "name" => name} = payload
    {int_id, _} = Integer.parse(id)
    time = DateTime.utc_now()
    Messages.create_message(%{from: int_id, to: 2, content: msg, time: time})
    broadcast socket, "shout", payload
    # broadcast("popo:" <> "2" , "shout", payload) #sends the message to all connected clients for the to_user
    {:noreply, socket}
  end

  def handle_out("shout", payload, socket) do
    IO.puts ">>>>>>>handle out"
    IO.puts "socket"
    IO.inspect socket.assigns
    IO.puts "payload"
    IO.inspect payload
    
    if socket.assigns[:user] == payload["to"] || socket.assigns[:user] == payload["id"] do
      push socket, "shout", payload
    end
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
