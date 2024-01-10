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


## Environment Setup [🔗](https://book.dojoengine.org/getting-started/setup.html)

Install Rust + Cargo + others

```
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# open new terminal to update PATH
rustup override set stable
rustup update

# Install Cargo
curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh

# other stuff you might need
cargo install toml-cli
brew install protobuf
```

Install the [Cairo 1.0](https://marketplace.visualstudio.com/items?itemName=starkware.cairo1) extension for Visual Studio Code


### Install Dojo [🔗](https://book.dojoengine.org/getting-started/quick-start.html)

Using Dojo 0.4.3!

```console
curl -L https://install.dojoengine.org | bash
# open new terminal to update PATH
dojoup -v 0.4.3

# test dojo
cd dojo
sozo build
sozo test

# install packages
cd ../client
yarn
```


## Launch Dojo

#### Terminal 1: Katana (local node)

```console
cd dojo
katana --disable-fee --invoke-max-steps 10000000

# or just...
cd dojo
./run_katana
```

#### Terminal 2: Torii (indexer)

Uncomment the `world_address` parameter in `dojo/Scarb.toml` then:

```console
cd dojo
torii --world 0x6400412d8083e10058277920b8a4a81338727912bc3435e5413f168221e73c7

# or just...
cd dojo
./run_torii
```

#### Terminal 3: Client

```console
cd client
yarn && yarn dev

# or just...
cd dojo
./run_client
```

#### Terminal 4: Sozo commands

```console
# build world and systems
cd dojo
sozo build

# migrate to local Katana
cd dojo
./migrate
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

# or just...
cd dojo
./migrate
```

## FAQ / Pitfalls

* `sozo migrate` error:

```
[1] 🌎 Building World state....
  > Found remote World: 0x3cc6a9ed7c1e2485d4fe787a7191f1f6835cd905a3d0731fc9e24f5a39d9415
  > Fetching remote state
error: Failed to build remote World state.

Caused by:
    Unable to find remote World at address 0x3cc6a9ed7c1e2485d4fe787a7191f1f6835cd905a3d0731fc9e24f5a39d9415. Make sure the World address is correct and that it is already deployed!
```

Fix: Comment `world_address` on `Scarb.toml`, migrate, and uncomment.


* Console error:

`Error: code=ContractNotFound, message="Contract not found"`

Fix: Delete burner wallets from Browser Local Storage




