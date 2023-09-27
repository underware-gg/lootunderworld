import './App.css';
import Burner from './Burner';
import Example from './Example';
import Minter from '../underworld/components/Minter';
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
      <Minter />
      <hr />
      <Example />
    </>
  );
}

export default App;
