# Loot Underworld

Granted by Frontinus House / BibliothecaDAO

[Original Proposal](https://github.com/BibliothecaDAO/Frontinus-House-Docs/issues/26)

## Game Design

yadda yadda yadda



## Dojo React Quick Start Guide

From [dojo-starter-react-app](https://github.com/dojoengine/dojo-starter-react-app)

### Initial Setup

The repository already contains the `dojo` as a submodule. Feel free to remove it if you prefer.

**Prerequisites:** First and foremost, ensure that Dojo is installed on your system. If it isn't, you can easily get it set up with:

```console
curl -L https://install.dojoengine.org | bash
```

Now install/update dojo with [`dojoup`](https://book.dojoengine.org/toolchain/dojoup.html) also to update Dojo.
... 

```console
# latest stable
dojoup
# or the nightly
dojoup -v nightly
```

For an in-depth setup guide, consult the [Dojo book](https://book.dojoengine.org/getting-started/quick-start.html).

### Launch the Example in Under 30 Seconds

After cloning the project, execute the following:

1. **Terminal 1 - Katana**:

```console
cd dojo
katana --disable-fee
```

2. **Terminal 2 - Contracts**:

```console
cd dojo
sozo build && sozo migrate

// Basic Auth - This will allow burner Accounts to interact with the contracts
sozo auth writer Position move
sozo auth writer Position spawn
sozo auth writer Moves move
sozo auth writer Moves spawn
```

3. **Terminal 3 - Client**:

You need this [`.env`](https://github.com/dojoengine/dojo-starter-react-app/blob/main/client/.env) in your `client` folder.

```console
cd client
yarn && yarn dev
```

4. **Terminal 4 - Torii**:

Uncomment the 'world_address' parameter in `dojo/Scarb.toml` then:

```console
cd dojo
torii
```

Upon completion, launch your browser and navigate to http://localhost:5173/. You'll be greeted by the running example!