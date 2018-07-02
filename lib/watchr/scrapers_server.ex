defmodule Watchr.ScrapersServer do
  use GenServer

  ##############
  # Client API #
  ##############

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def create_scraper(%Watchr.Page{} = page, %Watchr.ContentChain{} = content_chain) do
    GenServer.call(__MODULE__, {:create_scraper, page, content_chain})
  end

  def get_pid(page_id) do
    GenServer.call(__MODULE__, {:get_pid, page_id})
  end

  ####################
  # Server Callbacks #
  ####################

  def init(_arg) do
    {:ok, %{pids: %{}}}
  end

  # calls

  def handle_call({:create_scraper, page, content_chain}, _from, state) do
    {:ok, pid} = Watchr.ScrapersSupervisor.start_scraper_sup(page, content_chain)
    [scraper, scraper_server] = Supervisor.which_children(pid)
    {_, scraper_pid, _, _} = scraper
    {_, scraper_server_pid, _, _} = scraper_server
    pids = Map.put(state.pids, page.id, scraper_server_pid)
    new_state = %{state | pids: pids}
    {:reply, {:ok, scraper_server_pid}, new_state}
  end

  def handle_call({:get_pid, page_id}, _from, state) do
    {:reply, {:ok, state.pids[page_id]}, state}
  end
end
