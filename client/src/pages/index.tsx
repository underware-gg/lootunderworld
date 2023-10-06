import './index.css';
import React from 'react';
import ReactDOM from 'react-dom/client';
import { useAsciiText, deltaCorpsPriest1 } from 'react-ascii-text';

function IndexPage() {
  //@ts-ignore
  const textStyle: UseAsciiTextArgs = {
    animationCharacters: "▒ ░ █",
    animationDirection: "down",
    animationInterval: 0,
    animationLoop: false,
    animationSpeed: 20,
    font: deltaCorpsPriest1,
  }
  const Text1Ref = useAsciiText({
    ...textStyle,
    text: [" ", "LooT"],
  });
  const Text2Ref = useAsciiText({
    ...textStyle,
    text: [" ", "Underworld"],
  });

  return (
    <div className="card">
      {/* @ts-ignore */}
      <pre ref={Text1Ref}></pre>
      {/* @ts-ignore */}
      <pre ref={Text2Ref}></pre>
      
      <div className='Spacer20' />
      <h2><button onClick={() => { location.href = '/underworld/' }}>ENTER</button></h2>

      <div className='Spacer20' />
      <h2><button onClick={() => { location.href = '/editor/' }}>BITMAP EDITOR</button></h2>

      <br/>
      <div className='Spacer20' />
      <a href='/test/'>test page</a>
    </div>
  );
}


async function init() {
  const rootElement = document.getElementById('root');
  if (!rootElement) throw new Error('React root not found');
  const root = ReactDOM.createRoot(rootElement as HTMLElement);
  root.render(
    <React.StrictMode>
      <IndexPage />
    </React.StrictMode>
  );
}

init();