defmodule Watchr.ScraperSupervisor do
  use Supervisor

  ##############
  # Client API #
  ##############

  def start_link({%Watchr.Page{} = page, %Watchr.ContentChain{} = content_chain}) do
    Supervisor.start_link(__MODULE__, {page, content_chain})
  end

  ####################
  # Server Callbacks #
  ####################

  def init({page, content_chain}) do
    children = [
      {Watchr.ScraperServer, content_chain},
      {Watchr.Scraper, page}
    ]
    opts = [strategy: :one_for_one]

    Supervisor.init(children, opts)
  end
end
