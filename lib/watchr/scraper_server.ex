defmodule Watchr.ScraperServer do
  use GenServer

  ##############
  # Client API #
  ##############

  def start_link(%Watchr.ContentChain{} = content_chain) do
    GenServer.start_link(__MODULE__, content_chain)
  end

  ####################
  # Server Callbacks #
  ####################

  def init(content_chain) do
    {:ok, content_chain}
  end
end
