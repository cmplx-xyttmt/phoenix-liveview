defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  def mount(_oarams, _session, socket) do
    IO.inspect(self(), label: "MOUNT")
    socket = assign(socket, brightness: 10)
    IO.inspect(socket)
    {:ok, socket}
  end

  def render(assigns) do
    IO.inspect(self(), label: "RENDER")
    ~H"""
    <h1>Front Porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style={"width: #{@brightness}%"}>
          <%= @brightness %>%
        </span>
      </div>
      <button phx-click="off">
        <img src="/images/light-off.svg"/>
      </button>
      <button phx-click="down">
        <img src="/images/down.svg"/>
      </button>
      <button phx-click="random">
        <img src="/images/fire.svg"/>
      </button>
      <button phx-click="up">
        <img src="/images/up.svg"/>
      </button>
      <button phx-click="on">
        <img src="/images/light-on.svg"/>
      </button>
    </div>
    """
  end

  def handle_event("on", _, socket) do
    IO.inspect(self(), label: "ON")

    socket = assign(socket, brightness: 100)

    {:noreply, socket}
  end

  def handle_event("off", _, socket) do
    IO.inspect(self(), label: "OFF")
    socket = assign(socket, brightness: 0)
    {:noreply, socket}
  end

  def handle_event("up", _, socket) do
    IO.inspect(self(), label: "UP")
    brightness = socket.assigns.brightness
    socket = assign(socket, brightness: min(100, brightness + 10))
    {:noreply, socket}
  end

  def handle_event("down", _, socket) do
    brightness = socket.assigns.brightness
    socket = update(socket, :brightness, &max(0, &1 - 10))
    {:noreply, socket}
  end

  def handle_event("random", _, socket) do
    random_brightness = Enum.random(0..100)
    socket = assign(socket, brightness: random_brightness)
    {:noreply, socket}
  end
end
