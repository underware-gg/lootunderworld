import './index.css';
import React from 'react';
import ReactDOM from 'react-dom/client';
import EditorPage from '../underworld/components/EditorPage';

async function init() {
  const rootElement = document.getElementById('root');
  if (!rootElement) throw new Error('React root not found');
  const root = ReactDOM.createRoot(rootElement as HTMLElement);
  root.render(
    <React.StrictMode>
      <EditorPage />
    </React.StrictMode>
  );
}

init();