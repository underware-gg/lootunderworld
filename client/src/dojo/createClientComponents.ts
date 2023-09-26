import { overridableComponent } from "@latticexyz/recs";
import { SetupNetworkResult } from "./setupNetwork";


export type ClientComponents = ReturnType<typeof createClientComponents>;

export function createClientComponents({ contractComponents }: SetupNetworkResult) {
  return {
    ...contractComponents,
    // Loot Underworld
    Chamber: overridableComponent(contractComponents.Chamber),
    Map: overridableComponent(contractComponents.Map),
    Doors: overridableComponent(contractComponents.Doors),
    Tile: overridableComponent(contractComponents.Tile),
    // Example
    Position: overridableComponent(contractComponents.Position),
    Moves: overridableComponent(contractComponents.Moves),
  };
}