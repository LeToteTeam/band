defmodule Metrix.Instrumenter.Ecto do
  alias Metrix.Stats

  def log(entry) do
    log_queue_time(entry)
    log_query_time(entry)
    log_decode_time(entry)
    log_total_time(entry)
    entry
  end

  def log_queue_time(entry) do
    metric = metric_name("queue", entry)
    time = value(entry.queue_time)
    Stats.histogram(metric, time)
  end

  def log_query_time(entry) do
    metric = metric_name("query", entry)
    time = value(entry.query_time)
    Stats.histogram(metric, time)
  end

  def log_decode_time(entry) do
    metric = metric_name("decode", entry)
    time = value(entry.decode_time)
    Stats.histogram(metric, time)
  end

  def log_total_time(entry) do
    metric = metric_name("total", entry)
    time = total_time(entry)
    Stats.histogram(metric, time)
  end

  defp total_time(entry) do
    total =
      zero_if_nil(entry.queue_time) +
      zero_if_nil(entry.query_time) +
      zero_if_nil(entry.decode_time)

    Stats.microseconds(total)
  end

  defp value(value) do
    value
    |> zero_if_nil
    |> Stats.microseconds
  end

  defp zero_if_nil(nil), do: 0
  defp zero_if_nil(value), do: value

  defp metric_name(metric, entry) do
    "ecto.query.duration.#{metric}.#{result(entry)}"
  end

  defp result(query) do
    case query.result do
      {:ok, _} ->
        "ok"
      {:error, _} ->
        "error"
    end
  end
end
