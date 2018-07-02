defmodule Watchr.ContentChain do
  defstruct contents: []

  @doc """
  Create a new ContentChain struct.
  """
  def new() do
    {:ok, %Watchr.ContentChain{}}
  end

  @doc """
  Add a new Content to the ContentChain
  """
  def add(%Watchr.ContentChain{} = content_chain, %Watchr.Content{} = content) do
    {:ok, %{content_chain | contents: [content | content_chain.contents]}}
  end
end
