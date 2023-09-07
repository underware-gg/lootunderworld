# Loot Underworld

Granted by Frontinus House / BibliothecaDAO

[Original Proposal](https://github.com/BibliothecaDAO/Frontinus-House-Docs/issues/26)

## Game Design Notes

##### Alternative 1

* A Realm is 50x50 km
* A Chamber is 40x40 m
* We can fit exactly 1250x1250 Chambers inside a Realm
* Or 1.562.500 Chambers, per level depth

##### Alternative 2

* A Realm is 50x50 km
* The Realms SVG viewbox is 1000x1000p, less the 50p borders, 900x900 points
* We could consider to fit exactly 900x900 Chambers to make it 1:1 to the Realms SVG scale.
* Or 810.000 Chambers, per level depth
* Each Chamber would have 55,55x55,55 meters



## Dojo Quick Start Guide

Cloned from the [dojo-starter-react-app](https://github.com/dojoengine/dojo-starter-react-app)

For an in-depth setup guide, consult the [Dojo book](https://book.dojoengine.org/getting-started/quick-start.html).

### Development Setup [🔗](https://book.dojoengine.org/getting-started/setup.html)

Install Rust + Cargo + others

```
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup override set stable
rustup update
cargo test

# Install Cargo
curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh

# other stuff you might need
brew install protobuf
```

Install the [Cairo 1.0](https://marketplace.visualstudio.com/items?itemName=starkware.cairo1) extension for Visual Studio Code


### Install Dojo [🔗](https://book.dojoengine.org/getting-started/quick-start.html)

```console
curl -L https://install.dojoengine.org | bash
dojoup
```


### Update Dojo [🔗](https://book.dojoengine.org/toolchain/dojoup.html)

```console
# latest stable
dojoup
# install specific version
dojoup -v 0.2.1
# install the nightly
dojoup -v nightly
# install specific branch
dojoup -b main
# install specific commit
dojoup -C 40ea4d86a9739fd85ca153f56668c8797bb3750f
# install fromo a path
dojoup -p ../../dojo
```


## Launch Dojo

#### Terminal 1: Katana (local node)

```console
cd dojo
katana --disable-fee
```

#### Terminal 2: Contracts

```console
cd dojo
sozo build && sozo migrate

# authorize burner Accounts to interact with the contracts
sozo auth writer Position move
sozo auth writer Position spawn
sozo auth writer Moves move
sozo auth writer Moves spawn
```

#### Terminal 3: Torii (indexer)

Uncomment the `world_address` parameter in `dojo/Scarb.toml` then:

```console
cd dojo
torii
```

#### Terminal 4: Client

You need this [`.env`](https://github.com/dojoengine/dojo-starter-react-app/blob/main/client/.env) in your `client` folder.

```console
cd client
yarn && yarn dev
```

#### Browser

Open [http://localhost:5173/](http://localhost:5173/)


