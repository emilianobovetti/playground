defmodule SomeStruct do
  defstruct field_a: nil,
            field_b: []

  def i_send_a_struct do
    DialyzerPlayground.i_take_a_map(%{
      field_a: "hello",
      field_b: []
    })
  end
end
