defmodule Watchr.PagesServer do
  use GenServer

  ##############
  # Client API #
  ##############

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def add_page(%Watchr.Page{} = page) do
    GenServer.call(__MODULE__, {:add_page, page})
  end

  def get_all_pages() do
    GenServer.call(__MODULE__, :get_all_pages)
  end

  def get_page(id) do
    GenServer.call(__MODULE__, {:get_page, id})
  end

  def update_page(page) do
    GenServer.cast(__MODULE__, {:update_page, page})
  end

  def delete_page(id) do
    GenServer.cast(__MODULE__, {:delete_page, id})
  end

  def get_content_chain(id) do
    GenServer.call(__MODULE__, {:get_content_chain, id})
  end

  def update_content_chain(id, %Watchr.ContentChain{} = new_content_chain) do
    GenServer.cast(__MODULE__, {:update_content_chain, id, new_content_chain})
  end

  def start_scrapers() do
    GenServer.cast(__MODULE__, :start_scrapers)
  end

  ####################
  # Server Callbacks #
  ####################

  def init(:ok) do
    pages = get_initial_pages()
    content_chains = pages |> get_content_chains
    {:ok, %{pages: pages, content_chains: content_chains}}
  end

  # calls

  def handle_call({:add_page, page}, _from, state) do
    updated_pages = Map.put(state.pages, page.id, page)
    {:reply, :ok, %{state | pages: updated_pages}}
  end

  def handle_call(:get_all_pages, _from, state) do
    {:reply, {:ok, state.pages}, state}
  end

  def handle_call({:get_page, id}, _from, state) do
    {:reply, {:ok, state.pages[id]}, state}
  end

  def handle_call({:get_content_chain, id}, _from, state) do
    {:reply, {:ok, state.content_chains[id]}, state}
  end

  # casts

  def handle_cast({:update_content_chain, id, new_content_chain}, state) do
    case Map.fetch(state.content_chains, id) do
      {:ok, _} ->
        updated_content_chains = Map.put(state.content_chains, id, new_content_chain)
        {:noreply, %{state | content_chains: updated_content_chains}}
      :error ->
        {:noreply, state}
    end
  end

  def handle_cast({:update_page, updated_page}, state) do
    case Map.fetch(state.pages, updated_page.id) do
      {:ok, _} ->
        updated_pages = Map.put(state.pages, updated_page.id, updated_page)
        {:noreply, %{state | pages: updated_pages}}
      :error ->
        {:noreply, state}
    end
  end

  def handle_cast({:delete_page, id}, state) do
    updated_pages = Map.delete(state.pages, id)
    {:noreply, %{state | pages: updated_pages}}
  end

  def handle_cast(:start_scrapers, state) do
    {:noreply, state}
  end

  ####################
  # Helper Functions #
  ####################

  defp get_initial_pages do
    %{"asdfghjklqwertyuiop" => %Watchr.Page{
        body: ~s({"some_key": "some value"}),
        headers: ["Conten-Type": "application/json"],
        id: "asdfghjklqwertyuiop",
        title: "example.com",
        url: "http://example.com/news",
        verb: :post
      },
      "qwertyuioplkjhgfdsa" => %Watchr.Page{
        body: ~s({"some_key": "some value"}),
        headers: ["Conten-Type": "application/json"],
        id: "qwertyuioplkjhgfdsa",
        title: "example.com 2",
        url: "http://example.com/news",
        verb: :post
      }
    }
  end

  defp get_content_chains(pages) do
    pages
    |> Map.keys
    |> get_content_chains(%{})
  end

  defp get_content_chains([], content_chains) do
    content_chains
  end

  defp get_content_chains([key|rest], content_chains) do
    chain = get_chain(key)
    content_chains = Map.put(content_chains, key, chain)
    get_content_chains(rest, content_chains)
  end

  defp get_chain(_page_id) do
    {:ok, chain} = Watchr.ContentChain.new()
    chain
  end
end
