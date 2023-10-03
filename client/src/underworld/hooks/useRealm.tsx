import { useMemo } from 'react'
import { useUnderworldContext } from '../hooks/UnderworldContext'
import { convertCityCenterToMeters, convertCityCenterToCompass, City } from '../utils/realms'
import { compassToCoord } from '../utils/underworld'

import useSWR from 'swr'
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
      let style = doc.getElementsByTagName('style')[0]
      style.innerHTML += `
svg {
  background-color: rgb(27, 27, 27);
}
path {
  stroke: rgb(193, 150, 93);
}
line {
  stroke: rgb(148, 99, 31);
}
text {
  // color: rgb(251, 246, 192);
  fill: rgba(251, 246, 192, 0.8)!important;
  stroke: none!important;
}
.SelectedCity {
  fill: rgb(251, 246, 192)!important;
  font-size: 50px!important;
}
text.SelectedCity {
  font-weight: bold;
}
circle.SelectedCity {
  stroke: rgb(251, 246, 192)!important;
  stroke-width: 10!important;
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
