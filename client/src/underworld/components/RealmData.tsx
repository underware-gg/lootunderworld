import { useEffect } from 'react'
import { useUnderworldContext } from '../hooks/UnderworldContext'
import { useRealmMetadata, useRealmSvgMetadata } from '../hooks/useRealm'

interface ChamberMapProps {
  realmId: number,
}

function RealmCitySelector({
  realmId,
}: ChamberMapProps) {
  const { cityIndex, dispatch, UnderworldActions } = useUnderworldContext()
  const { cities, svgData } = useRealmSvgMetadata(realmId)

  useEffect(() => {
    if (cityIndex === null && cities.length > 0) {
      _setSelectedCity(0)
    }
  }, [cityIndex, cities])

  const _setSelectedCity = (index: number) => {
    dispatch({
      type: UnderworldActions.SET_CITY_INDEX,
      payload: index,
    })
    dispatch({
      type: UnderworldActions.SET_CITY,
      payload: cities[index],
    })
  }

  return (
    <select value={cityIndex ?? 999} onChange={(e) => _setSelectedCity(parseInt(e.target.value))}>
      {cities.map((city: any, index: number) => {
        return <option value={index} key={city.name}>{city.description}</option>
      })}
    </select>
  )
}

function RealmData({
  realmId,
}: ChamberMapProps) {
  const { city } = useUnderworldContext()
  const { metadata } = useRealmMetadata(realmId)

  return (
    <div className='RealmData AlignTop'>
      <h1>
        {metadata.name}
      </h1>
      <h3>
        Realm #{realmId}
      </h3>

      <div>
        City: <RealmCitySelector realmId={realmId} />
        <p>
          Size: {city.radius}
        </p>
        <p>
          Elevation: {city.elevation}
        </p>
      </div>
    </div>
  )
}

export default RealmData
