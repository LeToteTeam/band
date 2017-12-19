defmodule Metrix.Instrumenters.Absinthe do
  alias Absinthe.Resolution
  alias Metrix.Stats

  @behaviour Absinthe.Middleware

  def instrument(middleware, %{__reference__: %{module: Absinthe.Type.BuiltIns.Introspection}}), do: middleware
  def instrument(middleware, _field), do: [__MODULE__ | middleware]

  def call(%Resolution{state: :unresolved}=res, _) do
    %{res | middleware: new_middleware(res)}
  end

  def after_resolve(%Resolution{state: :resolved}=res, [start_at: start_at, field: field, object: object]) do
    end_at = :erlang.monotonic_time()
    diff = end_at - start_at
    result =
      case res.errors do
        [] ->
          {:ok, res.value}
        errors ->
          {:error, errors}
      end

    observe(object, field, result, diff)

    res
  end

  defp observe(object, field, result, diff) do
    metric = metric_name(object, result)
    time   = Stats.microseconds(diff)
    tags   = [field(field), object(object)]
    Metrix.histogram(metric, time, tags: tags)
  end

  defp metric_name(:query, result) do
    "absinthe.query.#{result(result)}"
  end
  defp metric_name(_, result) do
    "absinthe.fields.#{result(result)}"
  end

  defp result({:ok, _}), do: "ok"
  defp result({:error, _}), do: "error"

  defp field(field), do: "field:#{field}"

  defp object(obj), do: "object:#{obj}"

  defp new_middleware(res) do
    res.middleware ++ after_middleware(res)
  end

  defp after_middleware(res), do: [
    {{__MODULE__, :after_resolve},
      start_at: :erlang.monotonic_time(),
      field: res.definition.schema_node.identifier,
      object: res.parent_type.identifier}
  ]
end
