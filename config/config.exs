use Mix.Config

config :gardex, led_list: [ :red, :green ] 
config :nerves_leds, names: [ red: "led0", green: "led1" ]
