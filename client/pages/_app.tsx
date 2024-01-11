// import 'semantic-ui-css/semantic.min.css'
import '/styles/styles.css'
import React from 'react'
import { UnderworldProvider } from '@/underworld/hooks/UnderworldContext'

function _app({ Component, pageProps }) {
  return (
    <UnderworldProvider>
      <Component {...pageProps} />
    </UnderworldProvider>
  )
}

export default _app
