defmodule Playground.AMQP do
  require Record

  for {tag, fields} <- Record.extract_all(from_lib: "amqp_client/include/amqp_client.hrl") do
    name =
      Atom.to_string(tag)
      |> String.replace(".", "_")
      |> String.downcase()
      |> String.to_atom()

    Record.defrecord(name, tag, fields)
  end
end
