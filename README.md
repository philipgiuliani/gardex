# Gardex

## Future plans
* [x] Add support for analogue sensors
* [x] Write logs of all sensors in a sqlite database
* [x] API interface
* [ ] Pumps should be triggered on certain conditions, defined in a pot
* [ ] It should be possible to connect to a weather forecast service
* [ ] Make it possible to configure the project easily (sensors, …)
* [ ] There are no tests yet, probably the watering logic should get some tests.

## Sample formwork plan
![Fritzing](https://raw.githubusercontent.com/philipgiuliani/gardex/master/fritzing/basic.jpg)

## Contributing
I would love to see other people contributing to this project.

### Installation
To build the project you have to setup all dependencies of nerves. They have a very simple [installation guide](https://hexdocs.pm/nerves/installation.html).

### Configuring
You have to configure your target ([supported targets](https://hexdocs.pm/nerves/targets.html)) in the `mix.exs` file and describe your setup in `apps/core/lib/core.ex`.

### Building
- `cd apps/fw && MIX_ENV=prod mix deps.get && MIX_ENV=prod mix deploy`
