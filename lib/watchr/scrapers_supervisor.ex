defmodule Watchr.ScrapersSupervisor do
  use DynamicSupervisor

  ##############
  # Client API #
  ##############

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_scrapers_server() do
    scrapers_server_spec = {Watchr.ScrapersServer, :ok}
    DynamicSupervisor.start_child(__MODULE__, scrapers_server_spec)
  end

  def start_scraper_sup(%Watchr.Page{} = page, %Watchr.ContentChain{} = content_chain) do
    scraper_supervisor_spec = {Watchr.ScraperSupervisor, {page, content_chain}}
    DynamicSupervisor.start_child(__MODULE__, scraper_supervisor_spec)
  end

  ####################
  # Server Callbacks #
  ####################

  def init(_arg) do
    result = DynamicSupervisor.init(strategy: :one_for_one)
    Watchr.AppState.set(:scrapers_sup_started)
    result
  end
end
