defmodule Apps.TrelloClone.Web.Live.Todo.Components.ItemModal.Title do
  @moduledoc """
  Item modal title, supports edition
  """
  use Phoenix.LiveComponent

  alias Apps.TrelloClone.Contexts.Todo

  @impl true
  def render(assigns) do
    ~L"""
    <div id="<%= @id %>">
      <%= if @editing do %>
        <form phx-target="<%= @myself %>" phx-submit="update_title">
          <input type="text" name="title" phx-hook="Focus" data-component="<%= @id %>" value="<%= @item.title %>"></input>
        </form>
      <% else %>
        <h5 class="modal-title" phx-click="start_editing" phx-target="<%= @myself %>">
          <%= @item.title %>
        </h5>
      <% end %>
    </div>
    """
  end

  @impl true
  def update(%{id: id, item: item} = _assigns, socket) do
    {:ok, assign(socket, id: id, item: item, editing: false)}
  end

  @impl true
  def handle_event("start_editing", _event, socket) do
    {:noreply, assign(socket, editing: true)}
  end

  @impl true
  def handle_event("cancel", _event, socket) do
    {:noreply, assign(socket, editing: false)}
  end

  @impl true
  def handle_event("update_title", %{"title" => new_title} = _event, socket) do
    {:ok, _list} = Todo.update_item(socket.assigns.item, %{title: new_title})
    {:noreply, socket}
  end
end
