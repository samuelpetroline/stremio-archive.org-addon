defmodule StremioArchiveOrgAddon.Decorators.LoggerDecorator do
  defmacro log(call) do
    quote do
      require Logger

      {name, _, args} = unquote(Macro.escape(call))

      Logger.debug("""
      ➡️  Entering #{__MODULE__}.#{name}
      """)

      Logger.info("""
      Parameters:
        #{inspect(args)}
      """)

      result = unquote(call)

      Logger.debug("""
      ⬅️  Exiting #{__MODULE__}.#{name}
      """)

      Logger.info("""
      Result:
        #{inspect(result)}
      """)

      result
    end
  end
end
