import Minter from './Minter';
import { useSyncWorld } from '../hooks/useGraphQLQueries';

function Underworld() {
  const { loading } = useSyncWorld();

  if (loading) {
    return <h1>loading...</h1>
  }

  return (
    <>
      <Minter />
    </>
  );
}

export default Underworld;
