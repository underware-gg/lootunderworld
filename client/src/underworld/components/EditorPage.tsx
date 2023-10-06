import { useState, useMemo, useEffect } from 'react'
import { MapColors } from '../utils/colors'
import { bigintToHex } from '../utils/utils'

function EditorPage() {
  return (
    <div className="card">
      <EditorMap />
    </div>
  )
}

function EditorMap() {
  const [bitmap, setBitmap] = useState(BigInt('0xfffea8b8aeee82a0fabea208fbeee802effa80a0febf88bfeebfa83caffe00e0'))
  const [activeTile, setActiveTile] = useState(-1)

  const tilemap = useMemo(() => {
    let result: number[] = []
    for (let i = 0; i < 256; ++i) {
      const bit = bitmap & (BigInt(1) << BigInt(255 - i))
      result.push(bit ? 1 : 0)
    }
    return result
  }, [bitmap])
  useEffect(() => console.log(`EDITOR tilemap:`, bigintToHex(bitmap), tilemap), [tilemap])

  const _setTileBit = (index: number) => {
    setBitmap(bitmap ^ (BigInt(1) << BigInt(255 - index)))
  }

  const _tileRect = (index: number) => {
    if (index < 0) return null
    const x = index % 16
    const y = Math.floor(index / 16)
    const bit = tilemap[index]
    const fill = bit ? MapColors.LOCKED : ((x + y) % 2 == 0) ? MapColors.BG1 : MapColors.BG2
    const stroke = activeTile == index ? '#fff' : MapColors.BG1
    return <rect
      key={`t_${index}`}
      x={x}
      y={y}
      width='1'
      height='1'
      fill={fill}
      stroke={stroke}
      strokeWidth={0.05}
      onMouseEnter={() => setActiveTile(index)}
      onMouseLeave={() => setActiveTile(-1)}
      onClick={() => _setTileBit(index)}
    />
  }

  return (
    <div>
      <svg width='400' height='400' viewBox={`0 0 16 16`}>
        <style>{`svg{background-color:${MapColors.BG1}}`}</style>
        {tilemap.map((bit: number, index: number) => _tileRect(index))}
        {_tileRect(activeTile)}
      </svg>
      <p>
        Tile: [<b>{activeTile < 0 ? '-' : activeTile}</b>]
        X: [<b>{activeTile < 0 ? '-' : (activeTile % 16)}</b>]
        Y: [<b>{activeTile < 0 ? '-' : Math.floor(activeTile / 16)}</b>]
        Bit: [<b>{activeTile < 0 ? '-' : (255 - activeTile)}</b >]
      </p>
      <p>
        {bigintToHex(bitmap)}
      </p>
      <p>
        <button onClick={() => setBitmap(0n)}>clear</button>
        &nbsp;
        <button onClick={() => setBitmap(bitmap ^ BigInt('0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'))}>invert</button>
        &nbsp;
        /
        &nbsp;
        <button onClick={() => { navigator?.clipboard?.writeText(bigintToHex(bitmap)) }}>copy</button>
        &nbsp;
        <button onClick={async () => { setBitmap(BigInt(await navigator?.clipboard?.readText() ?? bitmap)) }}>paste</button>
      </p>
    </div>
  )
}



export default EditorPage
