import { map, clamp } from "./utils"
import { Compass } from "./underworld"

export interface Point {
  x: number
  y: number
}

export interface City {
  name: string,
  description: string,
  center: Point,
  radius: number
  elevation: number,
  meters: Point,
  compass: Compass,
  coord: bigint,
  selected: boolean,
}

export const convertCityCenterToMeters = (center: Point): Point => {
  return {
    x: map(center.x, -450, 450, 0, 80000),
    y: map(center.y, -450, 450, 0, 80000),
  }
}

export const convertCityCenterToCompass = (center: Point): Compass => {
  const m = convertCityCenterToMeters(center)
  const mx = clamp(Math.ceil(m.x / 40), 1, 2000)
  const my = clamp(Math.ceil(m.y / 40), 1, 2000)
  return {
    north: my <= 1000 ? (1000 - my + 1) : 0,
    east: mx > 1000 ? (mx - 1000) : 0,
    west: mx <= 1000 ? (1000 - mx + 1) : 0,
    south: my > 1000 ? (my - 1000) : 0,
  }
}
