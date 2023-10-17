import React, { ReactNode, createContext, useReducer, useContext, useEffect } from 'react'
import realmsMetadata from '../data/database.json'
import { makeRealmEntryChamberIdFromCoord } from '../utils/underworld'
import { City } from '../utils/realms'

//
// React + Typescript + Context
// https://react-typescript-cheatsheet.netlify.app/docs/basic/getting-started/context
//

//--------------------------------
// Constants
//
export const initialState = {
  realmId: 1, //6915,
  cityIndex: null,
  city: null,
  chamberId: 0n,
  // constants
  logo: '/pubic/logo.png',
  realmsMetadata,
}

const UnderworldActions = {
  SET_REALM_ID: 'SET_REALM_ID',
  SET_CITY_INDEX: 'SET_CITY_INDEX',
  SET_CITY: 'SET_CITY',
  SET_CHAMBER: 'SET_CHAMBER',
}

//--------------------------------
// Types
//
type UnderworldStateType = {
  realmId: number,
  cityIndex: number|null,
  city: City | null,
  chamberId: bigint,
  // constants
  logo: string,
  realmsMetadata: any,
}

type ActionType =
  | { type: 'SET_REALM_ID', payload: number }
  | { type: 'SET_CITY_INDEX', payload: number }
  | { type: 'SET_CITY', payload: any }
  | { type: 'SET_CHAMBER', payload: bigint }



//--------------------------------
// Context
//
const UnderworldContext = createContext<{
  state: UnderworldStateType
  dispatch: React.Dispatch<any>
}>({
  state: initialState,
  dispatch: () => null,
})

//--------------------------------
// Provider
//
interface UnderworldProviderProps {
  children: string | JSX.Element | JSX.Element[] | ReactNode
}
const UnderworldProvider = ({
  children,
}: UnderworldProviderProps) => {
  const [state, dispatch] = useReducer((state: UnderworldStateType, action: ActionType) => {
    let newState = { ...state }
    switch (action.type) {
      case UnderworldActions.SET_REALM_ID: {
        newState.realmId = action.payload as number
        newState.cityIndex = null
        newState.city = null
        newState.chamberId = 0n
        break
      }
      case UnderworldActions.SET_CITY_INDEX: {
        newState.cityIndex = action.payload as number
        newState.city = null
        newState.chamberId = 0n
        break
      }
      case UnderworldActions.SET_CITY: {
        newState.city = action.payload ? { ...action.payload } : null
        newState.chamberId = action.payload ? makeRealmEntryChamberIdFromCoord(newState.realmId, action.payload.coord) : 0n
        break
      }
      case UnderworldActions.SET_CHAMBER: {
        newState.chamberId = action.payload
        break
      }
      default:
        console.warn(`UnderworldProvider: Unknown action [${action.type}]`)
        return state
    }
    return newState
  }, initialState)

  return (
    <UnderworldContext.Provider value={{ state, dispatch }}>
      {children}
    </UnderworldContext.Provider>
  )
}

export { UnderworldProvider, UnderworldContext, UnderworldActions }


//--------------------------------
// Hooks
//

export const useUnderworldContext = () => {
  const { state, dispatch } = useContext(UnderworldContext)
  return {
    ...state,
    dispatch,
    UnderworldActions,
  }
}

