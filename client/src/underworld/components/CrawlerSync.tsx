import React, { useEffect, useLayoutEffect, useMemo, useState } from 'react'
import { useUnderworldContext } from '@/underworld/hooks/UnderworldContext'
import { useChamber, useChamberMap } from '@/underworld/hooks/useChamber'
import { MapChamber, compassToMapViewPos } from '@/underworld/components/MapView'
import { Dir, DirNames, LootUnderworld } from '@avante/crawler-core'
import { useChamberData, useConsoleLog, useConsoleWarn, useLootUnderworld, useSideCoords } from '@avante/crawler-react'
import { ChamberDataModel } from '@avante/crawler-core/dist/views/view.chamberData'


// export const useSideCoords = <T extends ModuleInterface>(coord: BigIntIsh): bigint[] | null => {
//   const { client } = useCrawler<T>()
//   const sideCoords = useMemo(() => {
//     const _coord = Utils.toBigInt(coord)
//     return _coord ? client.chamberDirections.map(d => client.offsetCoord(_coord, d)) : null
//   }, [coord])
//   return sideCoords
// }

//--------------------------------------
// Sync maps from Dojo to CrawlerContext
//
export default function CrawlerSync() {
  const { underworld } = useLootUnderworld()
  const { cityEntryCoord } = useUnderworldContext()

  useEffect(() => {
    setLoaders(cityEntryCoord ? [cityEntryCoord] : [])
  }, [cityEntryCoord])

  // tilemap loaders
  const [loaders, setLoaders] = useState<bigint[]>([])
  const _addLoaders = (newLoaders: bigint[]) => {
    // this pattern can handle simultaneous state set
    // filter to keep unique values only
    setLoaders(o => ([...o, ...newLoaders].filter((v, i, a) => a.indexOf(v) === i)))
  }

  const preloaders = useMemo(() => {
    return loaders.map((coord: bigint) => {
      return <PreLoader key={coord.toString()} coord={coord} addLoaders={_addLoaders} />
    })
  }, [loaders])

  return <>{preloaders}</>
}


//--------------------------------------
// <PreLoader>
// for any map that might exist (edges)
//
interface LoaderProps {
  coord: bigint
  addLoaders(coords: bigint[]): void
}
function PreLoader({
  coord,
  addLoaders,
}: LoaderProps) {
  const { chamberExists } = useChamber(coord)
  const chamberData = useChamberData(coord)
  // useConsoleWarn(chamberData && [`chamberData:`, chamberData], [chamberData])

  return (
    <>
      {chamberExists && !chamberData && <Loader coord={coord} />}
      {chamberExists && <SideLoader coord={coord} addLoaders={addLoaders} />}
    </>
  )
}


//--------------------------------------
// <Loader>
// for existing Chambers only
// adds new Chambers
//
function Loader({
  coord,
}) {
  const { dispatchChamberData } = useLootUnderworld()
  const { token_id, yonder, seed } = useChamber(coord)
  const { bitmap, tilemap, doors, tiles, isLoading } = useChamberMap(coord)
  
  const chamberDataModel = useMemo<ChamberDataModel>(() => {
    return (coord && !isLoading) ? {
      tokenId: token_id,
      coord,
      bitmap,
      seed,
      yonder,
      tilemap,
      locks: Array(Object.values(doors).length).fill(true),
      doors: Object.values(doors),
    } : null
  }, [coord, isLoading])
  // useConsoleWarn([`chamberDataModel:`, chamberDataModel], [chamberDataModel])

  useEffect(() => {
    if (chamberDataModel) {
      dispatchChamberData(coord, chamberDataModel)
    }
  }, [chamberDataModel])

  return <></>
}

//--------------------------------------
// <SideLoader>
// for existing Chambers only
// Create Loaders for side chambers
//
function SideLoader({
  coord,
  addLoaders,
}: LoaderProps) {
  const { doors } = useChamberMap(coord)

  const sideCoords = useSideCoords<LootUnderworld.Module>(coord)
  useEffect(() => {
    if (sideCoords) {
      const existing = sideCoords.reduce((acc, coord, index) => {
        const name = DirNames[index].toLowerCase()
        if (doors[name]) acc.push(coord)
        return acc
      }, [])
      addLoaders(existing)
    }
  }, [sideCoords])

  return <></>
}

