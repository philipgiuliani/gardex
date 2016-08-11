# Gardex

## Structure
You can attach various sensors to the Raspberry PI. Currently i support (temperature, moisture, light).

Sample initialization code:
```elixir
# Start all sensors
Sensor.start_link(0x80, [name: :moisture])
Sensor.start_link(0x90, [name: :temperature])
Sensor.start_link(0xA0, [name: :light])

# Start the pump
Pump.start_link(17, [name: :pump])

# Assign all sensors to a pot, you can have multiple pots using the same pump.
# You can pass a PID or a name.
pot = %Pot{name: "Chilli", moisture: :moisture, temperature: :temperature, light: :light}

# Start a monitor which will monitor all of the pots assigned to a pump
Monitor.start_link(%{pump: :pump, pots: [pot]})
```

## Future plans
* [x] Add support for analogue sensors
* [ ] Pumps should be triggered on certain conditions, defined in a pot
* [ ] It should be possible to connect to a weather forecast service
* [ ] Make it possible to configure the project easily (sensors, …)
* [ ] There are no tests yet, probably the watering logic should get some tests.
* [ ] Write logs of all sensors in a sqlite database
* [ ] Webinterface (Plug or Phoenix) to monitor all sensors and pots

## Sample formwork plan
![Fritzing](https://raw.githubusercontent.com/philipgiuliani/gardex/master/fritzing/basic.jpg)

## Contributing
I would love to see other people contributing to this project.

### Installation
To build the project you have to setup all dependencies of nerves. They have a very simple [installation guide](https://hexdocs.pm/nerves/installation.html).

### Configuring
You have to configure your target ([supported targets](https://hexdocs.pm/nerves/targets.html)) in the `mix.exs` file and setup your sensors/pump in `lib/gardex.ex`.

### Building
- `mix compile`
- `mix firmware`
- `mix firmware.burn`
