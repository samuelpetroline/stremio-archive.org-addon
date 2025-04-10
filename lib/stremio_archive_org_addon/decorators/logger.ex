defmodule StremioArchiveOrgAddon.Decorators.Logger do
  defmacro log(call) do
    quote do
      require Logger

      {name, _, args} = unquote(Macro.escape(call))

      Logger.debug("""
      ➡️  Entering #{__MODULE__}.#{name}
      Parameters:
        #{inspect(args, pretty: true, width: 80)}
      """)

      result = unquote(call)

      Logger.info("""
      ⬅️  Exiting #{__MODULE__}.#{name}
      Result:
        #{inspect(result, pretty: true, width: 80)}
      """)

      result
    end
  end
end
