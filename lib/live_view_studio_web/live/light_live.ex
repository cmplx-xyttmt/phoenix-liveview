defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  def mount(_oarams, _session, socket) do
    IO.inspect(self(), label: "MOUNT")
    socket = assign(socket, brightness: 10, temperature: 3000)
    IO.inspect(socket)
    {:ok, socket}
  end

  def render(assigns) do
    IO.inspect(self(), label: "RENDER")
    ~H"""
    <h1>Front Porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style={"width: #{@brightness}%; background: #{temp_color(@temperature)}"}>
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
      <form phx-change="slide">
        <input type="range" min="0" max="100" name="brightness" value={@brightness} />
      </form>
      <form phx-change="change-temp">
        <div class="temps">
          <%= for temp <- ["3000", "4000", "5000"] do %>
            <div>
              <input checked={String.to_integer(temp) == @temperature} type="radio" id={temp} name="temp" value={temp}/>
              <label for={temp}><%= temp %></label>
            </div>
          <% end %>
        </div>
      </form>
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

  def handle_event("slide", params, socket) do
    %{"brightness" => brightness} = params
    socket =
      assign(socket,
        brightness: String.to_integer(brightness)
      )
    {:noreply, socket}
  end

  def handle_event("change-temp", params, socket) do
    %{"temp" => temp} = params
    socket = assign(socket, temperature: String.to_integer(temp))
    {:noreply, socket}
  end

  defp temp_color(3000), do: "#F1C40D"
  defp temp_color(4000), do: "#FEFF66"
  defp temp_color(5000), do: "#99CCFF"
end
