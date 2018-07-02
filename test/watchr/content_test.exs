defmodule Watchr.ContentTest do
  use ExUnit.Case
  doctest Watchr.Content

  test "create a new content struct" do
    {:ok, content} = Watchr.Content.new()
    assert content == %Watchr.Content{current: [], previous: [], datetime: ""}

    {:ok, content} = Watchr.Content.new(["a"], [], "2018-05-17 18:47:56")
    assert content == %Watchr.Content{current: ["a"], previous: [], datetime: "2018-05-17 18:47:56"}
  end

  test "update content" do
    {:ok, content} = Watchr.Content.new(["a"], [], "2018-05-17 18:47:56")
    incoming_content = ["a", "b"]
    {:ok, updated_content} = Watchr.Content.update(incoming_content, content, "2018-05-18 18:47:56")
    assert updated_content == %Watchr.Content{
      current: ["a", "b"],
      previous: ["a"],
      datetime: "2018-05-18 18:47:56"
    }

    incoming_content = ["a"]
    {:ok, updated_content} = Watchr.Content.update(incoming_content, content, "2018-05-18 18:47:56")
    assert updated_content == content
  end

  test "get new data (if any) from content" do
    {:ok, content} = Watchr.Content.new(["a"], ["a"], "2018-05-17 18:47:56")
    {:ok, new_data} = Watchr.Content.get_new_data(content)
    assert new_data == []

    {:ok, content} = Watchr.Content.new(["a", "b", "c"], ["a"], "2018-05-17 18:47:56")
    {:ok, new_data} = Watchr.Content.get_new_data(content)
    assert new_data == ["b", "c"]
  end

  test "get removed data (if any) form content" do
    {:ok, content} = Watchr.Content.new(["b"], ["a", "b"], "2018-05-17 18:47:56")
    {:ok, removed_data} = Watchr.Content.get_removed_data(content)
    assert removed_data == ["a"]

    {:ok, content} = Watchr.Content.new(["a", "b"], ["a", "b"], "2018-05-17 18:47:56")
    {:ok, removed_data} = Watchr.Content.get_removed_data(content)
    assert removed_data == []
  end

  test "calculate the change event" do
    {:ok, content} = Watchr.Content.new()
    {:ok, event} = Watchr.Content.calculate_event(content)
    assert event == :equal

    {:ok, content} = Watchr.Content.new(["a"], [], "2018-05-17 18:47:56")
    {:ok, event} = Watchr.Content.calculate_event(content)
    assert event == :plus

    {:ok, content} = Watchr.Content.new(["b"], ["a", "b"], "2018-05-17 18:47:56")
    {:ok, event} = Watchr.Content.calculate_event(content)
    assert event == :less

    {:ok, content} = Watchr.Content.new(["b", "c"], ["a", "b"], "2018-05-17 18:47:56")
    {:ok, event} = Watchr.Content.calculate_event(content)
    assert event == :plus_less

  end
end
