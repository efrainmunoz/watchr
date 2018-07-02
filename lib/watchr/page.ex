defmodule Watchr.Page do
  defstruct id: "", title: "", url: "", verb: :get, headers: [], body: "", type: ""

  def new(id, title, url, verb, headers, body, type) do
    page = %Watchr.Page{
      id: id,
      title: title,
      url: url,
      verb: verb,
      headers: headers,
      body: body,
      type: type
    }
    {:ok, page}
  end
end
