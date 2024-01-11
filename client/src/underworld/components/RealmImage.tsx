import { useUnderworldContext } from '@/underworld/hooks/UnderworldContext'
import { useRealmSvgMetadata } from '@/underworld/hooks/useRealm'
import Svg from '@/underworld/components/Svg'

interface ChamberMapProps {
  // realmId: number,
}

function RealmImage({
  // realmId,
}: ChamberMapProps) {
  const { realmId } = useUnderworldContext()
  const { svgData } = useRealmSvgMetadata(realmId)

  return (
    <div className='RealmImage'>
      <Svg className='RealmImage' content={svgData} />
    </div>
  )
}

export default RealmImage
