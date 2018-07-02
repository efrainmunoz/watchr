defmodule Watchr.PagesSupervisor do
  use DynamicSupervisor

  ##############
  # Client API #
  ##############

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_pages_server() do
    child_spec = {Watchr.PagesServer, :ok}
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def start_scrapers_supervisor() do
    child_spec = {Watchr.ScrapersSupervisor, :ok}
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  ####################
  # Server Callbacks #
  ####################

  def init(:ok) do
    result = DynamicSupervisor.init(strategy: :one_for_one)
    Watchr.AppState.set(:pages_sup_started)
    result
  end
end
