defmodule Slackbot.Responders.Pots do
  use Hedwig.Responder

  @usage """
  gardex pots - Responds with a list of pots
  """
  respond ~r/pots$/i, msg do
    reply msg, "TODO: Return a list of pots"
  end
end
