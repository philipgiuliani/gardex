defmodule Slackbot.Responders.Pots do
  use Hedwig.Responder

  @usage """
  gardex pots - Responds with a list of pots
  """
  respond ~r/pots$/i, msg do
    IO.inspect msg
    reply msg, "TODO: Return a list of pots"
  end
end
