# Loot Underworld

```
##\                           ##\                               v0.1.0|      
## |                          ## |                                    |     
## |      ######\   ######\ ######\                                   |     
## |     ##  __##\ ##  __##\\_##  _|                              _  _|_  _ 
## |     ## /  ## |## /  ## | ## |                               |;|_|;|_|;|
## |     ## |  ## |## |  ## | ## |##\                            \\.    .  /
########\\######  |\######  | \####  |                            \\:  .  / 
\________|\______/  \______/   \____/                              ||:   |  
                                                            \,/    ||:   |  
##\   ##\   \,/           ##\                                      ||:   |  
## |  ## |        /`\     ## |                                     ||:   |  
## |  ## |#######\   ####### | ######\   ######\      /`\          ||:   |  
## |  ## |##  __##\ ##  __## |##  __##\ ##  __##\                  ||:   |  
## |  ## |## |  ## |## /  ## |######## |## |..\__|                 ||:   |  
## |  ## |## |  ## |## |  ## |##   ____|## |..                     ||:   |  
\######  |## |  ## |\####### |\#######\ ## |.  >D  @   ,`'`',      ||:   |  
 \______/ \__|  \__| \_______| \_______|\__|.  -!-/      `   `',   ||:   |  
      ____--`..''..'-~~_                 ....  / \   `    `    `', ||%~`--,_
 ~-~-~..................`~~---__-~,.-`~~--~^~~--.__,-, '        `%%%%%%%%`~~
##\......##\.....................##\.......##\...%%%%%%%%,  `     `%%%%%%%%% 
## | #\..## |....................## |......## |..%%#####..,    `     #####%%
## |###\.## | ######\   ######\  ## | ######$ |..################,---8;#####
## ## ##\## |##  __##\ ##  __##\ ## |##  __## |..###.............'   8'..###
####  _#### |## /..## |## |..\__|## |## /..## |..##...         '     8'...##
###  /.\### |## |..## |## |......## |## |..## |..##..  /   `      ,--#######
##  /...\## |\######  |## |......## |\####### |..##.  |$$|    '  ,##########
\__/.....\__| \______/ \__|......\__| \_______|..#####8---\,,,,,,##or080ro##
```

## Team

* Mataleone
  * GitHub: [@rsodre](https://github.com/rsodre)
  * Twitter: [@matalecode](https://twitter.com/matalecode)
* Recipromancer
  * GitHub: [@Rob-Morris](https://github.com/Rob-Morris)
  * Twitter: [@recipromancer](https://twitter.com/recipromancer)


## Background

A funDAOmental project as part of `Project or080ro`
  * GitHub: [@funDAOmental](https://github.com/funDAOmental/)
  * Twitter: [@funDAOmental](https://twitter.com/fundaomental)

Funded in part by a Frontinus House & BilbiothecaDAO grant in the FH genesis round. See the [Frontinius House proposal](https://github.com/BibliothecaDAO/Frontinus-House-Docs/issues/26) for Loot Underworld.


## Design

Take a look at the [DESIGN](DESIGN.md) doc.


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

# install packages
cd client
yarn
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
katana --disable-fee --invoke-max-steps 10000000
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
torii --world 0x76724b8917bd87868d80ae286a71ba7008a0d1a02381bc483fcfbe61d9b3ee0
```

#### Terminal 4: Client

You need this [`.env`](https://github.com/dojoengine/dojo-starter-react-app/blob/main/client/.env) in your `client` folder.

```console
cd client
yarn && yarn dev
```

#### Browser

Open [http://localhost:5173/](http://localhost:5173/)



## After edits...

#### Build, migrate, authorize

```console
cd dojo
sozo build
sozo migrate
scripts/default_auth.sh
cp target/dev/manifest.json ../client/src/
cd ../client
yarn run codegen

# or just...
cd dojo
./migrate
```

#### Run client codegen

```console
cd client
npm run codegen
```

## FAQ / Pitfalls

* `sozo migrate` error:

```
[1] 🌎 Building World state....
  > Found remote World: 0x76724b8917bd87868d80ae286a71ba7008a0d1a02381bc483fcfbe61d9b3ee0
  > Fetching remote state
error: Failed to build remote World state.

Caused by:
    Unable to find remote World at address 0x76724b8917bd87868d80ae286a71ba7008a0d1a02381bc483fcfbe61d9b3ee0. Make sure the World address is correct and that it is already deployed!
```

Fix: Comment `world_address` on `Scarb.toml`, migrate, and uncomment.


* Console error:

`Error: code=ContractNotFound, message="Contract not found"`

Fix: Delete burner wallets from Browser Local Storage




