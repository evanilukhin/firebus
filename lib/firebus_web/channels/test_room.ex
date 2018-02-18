defmodule FirebusWeb.TestRoom do
  use Phoenix.Channel

  intercept ["new_msg"]

  def join("test_room:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("test_room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast! socket, "new_msg", %{body: body}
    {:noreply, socket}
  end


  def handle_out("new_msg", payload, socket) do
    push socket, "new_msg", payload
    {:noreply, socket}
  end
end
