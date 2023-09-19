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

## Design Notes


### Coordinates / Distribution

Some ideas about Chamber distribution...

##### Alternative 1

* Considering a Realm is 80x80 km
* and a Chamber is 40x40 m
* then we can fit exactly 2000x2000 Chambers inside a Realm
* starting from the center of the Realm, 1000 Chambers in each direction
* total of 4 million Chambers, per level depth

##### Alternative 2

* Considering a Realm is 50x50 km
* and a Chamber is 40x40 m
* then we can fit exactly 1250x1250 Chambers inside a Realm
* or 1.562.500 Chambers, per level depth

##### Alternative 3

* Considering a Realm is 50x50 km
* The Realms SVG viewbox is 1000x1000p, less the 50p borders, 900x900 points
* We could consider to fit exactly 900x900 Chambers to make it 1:1 to the Realms SVG scale.
* Or 810.000 Chambers, per level depth
* Each Chamber would have 55,55x55,55 meters



