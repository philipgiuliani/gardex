defmodule Slackbot.Responders.Pots do
  use Hedwig.Responder

  @usage """
  gardex pots - Responds with a list of pots
  """
  hear ~r/\pots$/i, msg do
    IO.inspect msg
    reply msg, "Return pots"
  end
end
