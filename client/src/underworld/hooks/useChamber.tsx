import React, { useMemo } from "react"
import { Entity, HasValue, getComponentValue } from '@dojoengine/recs'
import { useComponentValue, useEntityQuery } from "@dojoengine/react"
import { useDojoComponents } from '@/dojo/DojoContext'
import { bigintToEntity } from "../utils/utils"
import { useEntityKeys, useEntityKeysQuery } from "@/underworld/hooks/useEntityKeys"
import { Dir, TileType } from "@avante/crawler-core"
import { useLootUnderworld } from "@avante/crawler-react"


//------------------
// All Chambers
//

export const useAllChamberIds = () => {
  const { Chamber } = useDojoComponents()
  // const entityIds: Entity[] = useEntityQuery([Has(Chamber)])
  // const chamberIds: bigint[] = useMemo(() => (entityIds ?? []).map((entityId) => BigInt(entityId)), [entityIds])
  const chamberIds: bigint[] = useEntityKeys(Chamber, 'location_id')
  return {
    chamberIds,
  }
}

export const useRealmChamberIds = (realmId: number) => {
  const { Chamber } = useDojoComponents()
  // const entityIds = useEntityQuery([HasValue(Chamber, { token_id: realmId })])
  // const chamberIds: bigint[] = useMemo(() => (entityIds ?? []).map((entityId) => BigInt(entityId)), [entityIds])
  const chamberIds: bigint[] = useEntityKeysQuery(Chamber, 'location_id', [HasValue(Chamber, { token_id: realmId })])
  return {
    chamberIds,
  }
}


//------------------
// Single Chamber
//

export const useChamber = (chamberId: bigint) => {
  const { Chamber } = useDojoComponents()

  const chamber: any = useComponentValue(Chamber, bigintToEntity(chamberId))
// useConsoleLog([`useChamber()`, Chamber, bigintToEntity(chamberId), chamber], [chamber])

  const seed = useMemo(() => BigInt(chamber?.seed ?? 0), [chamber])
  const minter = useMemo(() => BigInt(chamber?.minter ?? 0), [chamber])

  return {
    seed,
    minter,
    domain_id: chamber?.domain_id ?? 0,
    token_id: chamber?.token_id ?? 0,
    yonder: chamber?.yonder ?? 0,
    chamberExists: seed > 0,
  }
}

export const useChamberOffset = (chamberId: bigint, dir: Dir) => {
  const { underworld } = useLootUnderworld()
  const locationId = useMemo(() => underworld.offsetCoord(chamberId, dir), [chamberId, dir])
  const result = useChamber(locationId)
  return {
    locationId,
    ...result,
  }
}



//------------------
// Chamber Maps
// (used by <CrawlerSync> only)
//

export const useTiles = (locationId: bigint) => {
  const { Tile } = useDojoComponents()
  const tileIds: Entity[] = useEntityQuery([HasValue(Tile, { location_id: locationId ?? 0n })])
  const tiles: any[] = useMemo(() => tileIds.map((tileId) => getComponentValue(Tile, tileId)), [tileIds])
  // useConsoleLog([`TILES:`, tiles], [tileIds, tiles])
  return {
    tiles,
  }
}

export const useChamberMap = (locationId: bigint) => {
  const { Map } = useDojoComponents()

  const map: any = useComponentValue(Map, bigintToEntity(locationId))
  const bitmap: bigint = useMemo(() => BigInt(map?.bitmap ?? 0), [map])
  // useConsoleLog([`map:`, map, typeof map?.bitmap, bitmap], [bitmap])

  const doors = useMemo(() => {
    return {
      north: map?.north ?? 0,
      east: map?.east ?? 0,
      west: map?.west ?? 0,
      south: map?.south ?? 0,
      over: map?.over ?? 0,
      under: map?.under ?? 0,
    }
  }, [map])

  const { tiles } = useTiles(locationId)

  const tilemap = useMemo(() => {
    let result: number[] = []
    if (bitmap && tiles.length > 0) {
      for (let i = 0; i < 256; ++i) {
        const bit = bitmap & (BigInt(1) << BigInt(255-i))
        result.push(bit ? TileType.Path : TileType.Void)
      }
      tiles.forEach((tile) => {
        result[tile.pos] = tile.tile_type
      })
    }
    return result
  }, [bitmap, tiles])
  // useConsoleLog([`tilemap:`, Utils.bigIntToHex(bitmap)], [tilemap])

  return {
    bitmap,
    tilemap,
    doors,
    tiles,
    isLoading: (!map || !bitmap || !tiles?.length || !tilemap.length),
  }
}

export const useChamberState = (chamberId: bigint) => {
  const { State } = useDojoComponents()
  const state: any = useComponentValue(State, bigintToEntity(chamberId))
  return state ?? {}
}
