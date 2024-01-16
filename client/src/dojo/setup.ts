import { createClientComponents } from '@/dojo/createClientComponents'
import { createSystemCalls } from '@/dojo/createSystemCalls'
import { setupNetwork } from '@/dojo/setupNetwork'
import { getSyncEntities } from '@dojoengine/state'

export type SetupResult = Awaited<ReturnType<typeof setup>>

/**
 * Sets up the necessary components and network utilities.
 *
 * @returns An object containing network configurations, client components, and system calls.
 */
export async function setup() {
  // Initialize the network configuration.
  const network = await setupNetwork()

  // Create client components based on the network setup.
  const components = createClientComponents(network)

  // fetch all existing entities from torii
  await getSyncEntities(
    network.toriiClient,
    network.contractComponents as any
  )

  // Establish system calls using the network and components.
  //@ts-ignore
  const systemCalls = createSystemCalls(network)

  return {
    network,
    components,
    systemCalls,
  }
}