defmodule Watchr.Scraper do
  use GenServer

  ##############
  # Client API #
  ##############

  def start_link(page) do
    GenServer.start_link(__MODULE__, page)
  end

  def run(pid) do
    GenServer.call(pid, :run)
  end

  ####################
  # Server Callbacks #
  ####################

  def init(page) do
    {:ok, page}
  end

  # calls

  def handle_call(:run, _from, state) do
    {:reply, state, state}
  end
end
