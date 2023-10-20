import Burner from './Burner';
// import Example from './Example';
import TestMinter from '../underworld/components/TestMinter';
import { useSyncWorld } from '../underworld/hooks/useGraphQLQueries';

function App() {
  const { loading } = useSyncWorld();

  if (loading) {
    return <h1>loading...</h1>
  }

  return (
    <>
      <Burner />
      <hr />
      <TestMinter />
      <hr />
      {/* <Example /> */}
    </>
  );
}

export default App;
