defmodule Watchr.Content do
  defstruct current: [], previous: [], datetime: ""

  @doc """
  Create a new Content struct.
  """
  def new() do
    {:ok, %Watchr.Content{}}
  end

  def new(current, previous, datetime) do
    {:ok, %Watchr.Content{current: current, previous: previous, datetime: datetime}}
  end

  @doc """
  Update a content struct if there is a content change.
  """
  def update(incoming_content, %Watchr.Content{} = content, datetime) do
    case incoming_content == content.current do
      true ->
        {:ok, content}
      false ->
        {:ok, %Watchr.Content{current: incoming_content, previous: content.current, datetime: datetime}}
    end
  end

  @doc """
  Get new data (if any) from a Content struct.
  """
  def get_new_data(%Watchr.Content{} = content) do
    {:ok, content.current -- content.previous}
  end

  @doc """
  Get removed data (if any) from a Content struct.
  """
  def get_removed_data(%Watchr.Content{} = content) do
    {:ok, content.previous -- content.current}
  end

  @doc """
  Calculate the occured event from a Content struct.
  """
  def calculate_event(%Watchr.Content{} = content) do
    {:ok, new_data} = Watchr.Content.get_new_data(content)
    {:ok, removed_data} = Watchr.Content.get_removed_data(content)
    calculate_event(new_data, removed_data)
  end

  def calculate_event([], []),       do: {:ok, :equal}

  def calculate_event([_|_], []),    do: {:ok, :plus}

  def calculate_event([], [_|_]),    do: {:ok, :less}

  def calculate_event([_|_], [_|_]), do: {:ok, :plus_less}
end
