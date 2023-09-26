import './App.css';
import Burner from './Burner';
import Example from './Example';
import Minter from '../underworld/components/Minter';

function App() {
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
