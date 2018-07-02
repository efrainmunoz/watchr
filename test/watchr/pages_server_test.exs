defmodule Watchr.PagesServerTest do
  use ExUnit.Case
  doctest Watchr.PagesServer

  test "create a pages server" do
    {:ok, pid} = Watchr.PagesServer.start_link(:ok)
    assert Process.alive?(pid)
  end

  test "the pages server should add the initial pages on init" do
    Watchr.PagesServer.start_link(:ok)
    new_page = get_new_page()
    another_page = %{new_page | id: "qwertyuioplkjhgfdsa", title: "example.com 2"}
    {:ok, pages} = Watchr.PagesServer.get_all_pages()
    assert pages == %{new_page.id => new_page, another_page.id => another_page}
  end

  test "add a new page to the server" do
    Watchr.PagesServer.start_link(:ok)
    new_page = get_new_page()
    :ok = Watchr.PagesServer.add_page(new_page)
    assert {:ok, new_page} == Watchr.PagesServer.get_page(new_page.id)
  end

  test "update an existing page" do
    Watchr.PagesServer.start_link(:ok)
    new_page = get_new_page()
    updated_page = %{new_page | title: "sg3portal.com", url: "http://sg3portal.com/news"}

    Watchr.PagesServer.update_page(updated_page)

    {:ok, stored_page} = Watchr.PagesServer.get_page(updated_page.id)
    assert stored_page == updated_page
  end

  test "delete a page" do
    Watchr.PagesServer.start_link(:ok)
    Watchr.PagesServer.delete_page("qwertyuioplkjhgfdsa")
    assert {:ok, nil} == Watchr.PagesServer.get_page("qwertyuioplkjhgfdsa")
  end

  test "get all pages" do
    Watchr.PagesServer.start_link(:ok)
    new_page = get_new_page()
    another_page = %{new_page | id: "qwertyuioplkjhgfdsa", title: "example.com 2"}
    {:ok, pages} = Watchr.PagesServer.get_all_pages()
    assert pages == %{new_page.id => new_page, another_page.id => another_page}
  end

  test "get a page from the pages server" do
    Watchr.PagesServer.start_link(:ok)
    new_page = get_new_page()
    :ok = Watchr.PagesServer.add_page(new_page)

    assert {:ok, new_page} == Watchr.PagesServer.get_page(new_page.id)
    assert {:ok, nil} == Watchr.PagesServer.get_page("wrong key")
  end

  test "get ContentChain for a page" do
    Watchr.PagesServer.start_link(:ok)
    {:ok, expected} = Watchr.ContentChain.new()

    {:ok, content_chain} = Watchr.PagesServer.get_content_chain("asdfghjklqwertyuiop")
    assert content_chain == expected

    {:ok, content_chain} = Watchr.PagesServer.get_content_chain("qwertyuioplkjhgfdsa")
    assert content_chain == expected
  end

  test "update ContentChain for a page" do
    Watchr.PagesServer.start_link(:ok)
    {:ok, content_chain} = Watchr.ContentChain.new()
    {:ok, new_content} = Watchr.Content.new(["a"], [], "2018-05-22 15:58:00")
    {:ok, updated_content_chain} = Watchr.ContentChain.add(content_chain, new_content)

    Watchr.PagesServer.update_content_chain("asdfghjklqwertyuiop", updated_content_chain)

    {:ok, stored_chain} = Watchr.PagesServer.get_content_chain("asdfghjklqwertyuiop")
    assert stored_chain == updated_content_chain
  end

  ####################
  # Helper Functions #
  ####################

  defp get_new_page() do
    id = "asdfghjklqwertyuiop"
    title = "example.com"
    url = "http://example.com/news"
    verb = :post
    headers = ["Conten-Type": "application/json"]
    body = ~s({"some_key": "some value"})
    {:ok, new_page} = Watchr.Page.new(id, title, url, verb, headers, body)
    new_page
  end
end
