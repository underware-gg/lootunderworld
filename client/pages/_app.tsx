// import 'semantic-ui-css/semantic.min.css'
import '/styles/styles.css'
import React from 'react'
import { createClient, LootUnderworld } from '@avante/crawler-core'
import { CrawlerProvider } from '@avante/crawler-react'
import { UnderworldProvider } from '@/underworld/hooks/UnderworldContext'

const client = createClient(LootUnderworld.Id, true) // creates a new blank Module

function _app({ Component, pageProps }) {
  return (
    <CrawlerProvider client={client}>
      <UnderworldProvider>
        <Component {...pageProps} />
      </UnderworldProvider>
    </CrawlerProvider>
  )
}

export default _app
