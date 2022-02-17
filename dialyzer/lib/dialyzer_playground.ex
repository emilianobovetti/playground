defmodule DialyzerPlayground do
  @type t :: %{
          field_a: String.t() | nil,
          field_b: list(String.t())
        }

  @spec i_take_a_map(t) :: boolean()
  def i_take_a_map(%{field_a: <<_::binary-size(1), _::binary>>}), do: true
  def i_take_a_map(_), do: false
end
