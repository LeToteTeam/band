defmodule Metrix.Stats do
  use Statix

  def microseconds(time) do
    System.convert_time_unit(time, :native, :microsecond)
  end
end
