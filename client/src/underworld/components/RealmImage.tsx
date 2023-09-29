import { useRealmSvgMetadata } from '../hooks/useRealm'
import Svg from './Svg';

interface ChamberMapProps {
  realmId: number,
}

function RealmImage({
  realmId,
}: ChamberMapProps) {
  const { metadata, svgData } = useRealmSvgMetadata(realmId)

  return (
    <div className='RealmImage'>
      <Svg className='RealmImage' content={svgData} />
    </div>
  )
}

export default RealmImage
