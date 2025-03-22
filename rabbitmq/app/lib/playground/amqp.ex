defmodule Playground.AMQP do
  require Record

  for {tag, fields} <- Record.extract_all(from_lib: "amqp_client/include/amqp_client.hrl") do
    Atom.to_string(tag)
    |> String.replace(".", "_")
    |> String.to_atom()
    |> Record.defrecord(tag, fields)
  end
end
