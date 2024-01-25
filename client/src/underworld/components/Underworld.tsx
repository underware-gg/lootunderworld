import { UnderworldProvider } from '@/underworld/hooks/UnderworldContext'
import RealmImage from '@/underworld/components/RealmImage'
import RealmData from '@/underworld/components/RealmData'
import MinterMap from '@/underworld/components/MinterMap'
import MinterData from '@/underworld/components/MinterData'
import CrawlerSync from '@/underworld/components/CrawlerSync'

function Underworld() {
  return (
    <UnderworldProvider>
      <CrawlerSync />
      <div className="card RealmPanel">
        <RealmImage />
        <RealmData />
      </div>
      <div className="card MinterPanel">
        <MinterMap />
        <MinterData />
      </div>
    </UnderworldProvider>
  )
}

export default Underworld
