import { useMemo } from 'react'
import { useUnderworldContext } from '../hooks/UnderworldContext'

export const useRealmMetadata = (realmId: number) => {
  const { realmsMetadata } = useUnderworldContext()
  const metadata = useMemo(() => (realmsMetadata[realmId] ?? {}), [realmId])
  return {
    metadata,
  }
}
