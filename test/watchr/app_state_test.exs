defmodule Watchr.AppStateTest do
  use ExUnit.Case
  doctest Watchr.AppState

  test "start AppState gen server" do
    Watchr.AppState.start_link(:ok)
    state = Watchr.AppState.get()
    assert state == :app_started
  end

  test "state should be _state at the end of all" do
    Watchr.AppState.start_link(:ok)
    Watchr.PagesSupervisor.start_link(:ok)
    state = Watchr.AppState.get()
    assert state == :scrapers_sup_started
  end
end
