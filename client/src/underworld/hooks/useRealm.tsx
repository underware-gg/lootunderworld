import { useMemo } from 'react'
import { useUnderworldContext } from '../hooks/UnderworldContext'
import { convertCityCenterToMeters, convertCityCenterToCompass, City } from '../utils/realms'
import { compassToCoord } from '../utils/underworld'

import useSWR from 'swr'
import { RealmsColors } from '../utils/colors'
const textFetcher = (url: string) => fetch(url).then((res) => res.text())

export const useRealmMetadata = (realmId: number) => {
  const { realmsMetadata } = useUnderworldContext()
  const metadata = useMemo(() => (realmsMetadata[realmId] ?? {}), [realmId])
  return {
    metadata,
  }
}

export const useRealmSvgMetadata = (realmId: number) => {
  const { cityIndex } = useUnderworldContext()
  const { metadata } = useRealmMetadata(realmId)
  const { data, error, isLoading } = useSWR(metadata.image, textFetcher)
  // console.log(`DATA:`, data, error, isLoading)

  const { svgData, cities } = useMemo(() => {
    let svgData: string | null = null
    let cities: City[] = []

    if (data) {
      // convert svg text to HTMLDocument
      const parser = new DOMParser()
      const doc = parser.parseFromString(data as string, "application/xml")

      // modify style
      const _escapeColor = (c: string): string => c.replace('#', '%23')
      let style = doc.getElementsByTagName('style')[0]
      style.innerHTML += `
svg {
  background-color: ${_escapeColor(RealmsColors.BG)};
}
path {
  stroke: ${_escapeColor(RealmsColors.BORDERS)};
}
line {
  stroke: ${_escapeColor(RealmsColors.HILLS)};
}
text {
  fill: ${_escapeColor(RealmsColors.TEXT)}!important;
  stroke: none!important;
}
circle {
  fill: ${_escapeColor(RealmsColors.TEXT)}!important;
  stroke: ${_escapeColor(RealmsColors.TEXT)}!important;
}
.SelectedCity {
  fill: ${_escapeColor(RealmsColors.SELECTED)}!important;
	text-shadow: 0.07em 0.07em 1px ${_escapeColor(RealmsColors.BG)};
  font-size: 50px!important;
}
text.SelectedCity {
  font-weight: bold;
}
circle.SelectedCity {
  stroke-width: 10!important;
  stroke: ${_escapeColor(RealmsColors.SELECTED)}!important;
}
`
      // console.log(style)

      // get cities
      const cityElements: Element[] = Array.from(doc.getElementsByClassName('city'))
      const cityNames: Element[] = cityElements.reduce((result: Element[], el: Element) => { if (el.tagName == 'text') result.push(el); return result; }, [])
      const cityCenters: Element[] = cityElements.reduce((result: Element[], el: Element) => { if (el.tagName == 'circle') result.push(el); return result; }, [])
      // console.log(cityNames[0], cityCenters[0])

      // create cities
      for (let i = 0; i < Math.min(cityNames.length, cityCenters.length); ++i) {
        const circle = cityCenters[i] as SVGCircleElement
        const center = { x: circle.cx.baseVal.value, y: circle.cy.baseVal.value }
        const radius = circle.r.baseVal.value
        const name = cityNames[i].innerHTML
        const compass = convertCityCenterToCompass(center)
        let city: City = {
          name,
          description: `${name} (${radius})`,
          center,
          radius,
          elevation: -1,
          meters: convertCityCenterToMeters(center),
          compass,
          coord: compassToCoord(compass),
          selected: false,
        }
        if (i === cityIndex) {
          city.selected = true
          cityNames[i].setAttribute('class', 'city SelectedCity')
          cityCenters[i].setAttribute('class', 'city SelectedCity')
        }
        cities.push(city)
      }
      // console.log(cities)

      // convert back to text
      svgData = doc.documentElement.outerHTML
    }

    return {
      svgData,
      cities,
    }
  }, [data, cityIndex])

  return {
    metadata,
    svgData,
    cities,
    error,
    isLoading,
  }
}
