defmodule Watchr.PageTest do
  use ExUnit.Case
  doctest Watchr.Page

  test "create a new page" do
    id = "asdfghjklqwertyuiop"
    title = "example.com"
    url = "http://example.com/news"
    verb = :post
    headers = ["Content-Type": "application/json"]
    body = ~s({"some_key": "some value"})

    {:ok, page} = Watchr.Page.new(id, title, url, verb, headers, body)

    assert page == %Watchr.Page{
      id: id,
      title: title,
      url: url,
      verb: verb,
      headers: headers,
      body: body
    }
  end
end
