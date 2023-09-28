import './index.css';
import React from 'react';
import ReactDOM from 'react-dom/client';
import { DojoProvider } from '../DojoContext.tsx';
import { setup } from '../dojo/setup.ts';
import Underworld from '../underworld/components/Underworld.tsx';

async function init() {
  const rootElement = document.getElementById('root');
  if (!rootElement) throw new Error('React root not found');
  const root = ReactDOM.createRoot(rootElement as HTMLElement);
  const setupResult = await setup();
  root.render(
    <React.StrictMode>
      <DojoProvider value={setupResult}>
        <Underworld />
      </DojoProvider>
    </React.StrictMode>
  );
}

init();