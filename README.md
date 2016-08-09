# `gardex`

- `mix compile`
- `mix firmware`
- `mix firmware.burn`

## Available sensor types:
* Brightness
* Moisture
* Temperature

## Avaiable output types:
* Pump

## Example
```elixir
brightness = BrightnessSensor.start_link(17)
moisture = MoistureSensor.start_link(18)
temperature = TemperatureSensor.start_link(19)
hydrator = Pump.start_link(20)

chilli_pot = %Pot{
  brightness: brightness,
  moisture: moisture,
  temperature: temperature,
  hydrator: hydrator,
  hydrator_conditions: [
    brightness_max: 0.5,
    moisture_min: 1
  ]}

chilli_monitor = PotMonitor.start_link(chilli_pot)
```
