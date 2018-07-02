defmodule Watchr.AppState do
  use GenServer

  ##############
  # Client API #
  ##############

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  def set(new_state) do
    GenServer.cast(__MODULE__, {:set, new_state})
  end

  ####################
  # Server Callbacks #
  ####################

  def init(:ok) do
    {:ok, :app_started}
  end

  # calls

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  # casts

  def handle_cast({:set, :pages_sup_started}, _state) do
    Watchr.PagesSupervisor.start_scrapers_supervisor()
    {:noreply, :pages_sup_started}
  end

  def handle_cast({:set, :scrapers_sup_started}, _state) do
    Watchr.PagesSupervisor.start_pages_server()
    {:noreply, :scrapers_sup_started}
  end

  def handle_cast({:set, :pages_srv_started}, _state) do
    Watchr.ScrapersSupervisor.start_scrapers_server()
    {:noreply, :pages_srv_started}
  end

  def handle_cast({:set, :scrapers_srv_started}, state) do
  #  Watchr.PagesServer.start_scrapers()
    {:noreply, :scrapers_srv_started}
  end

  #def handle_cast({:set, :scrapers_started}, state) do
  #  {:noreply, :scrapers_started}
  #end
end
