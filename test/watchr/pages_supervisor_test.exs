defmodule Watchr.PagesSupervisorTest do
  use ExUnit.Case
  doctest Watchr.PagesSupervisor

  test "create a PagesSupervisor" do
    Watchr.PagesSupervisor.start_link(:ok)
    children = DynamicSupervisor.which_children(Watchr.PagesSupervisor)
    assert children == []
  end
end
