import { Account } from 'starknet';
import { getEvents, setComponentsFromEvents } from "@dojoengine/utils";
import { SetupNetworkResult } from './setupNetwork';
import { stringToFelt } from '../underworld/utils/utils';

export type SystemCalls = ReturnType<typeof createSystemCalls>;

export function createSystemCalls(
  { execute, provider, contractComponents }: SetupNetworkResult,
  // { Chamber, Map }: ClientComponents,
) {

  const mint_realms_chamber = async (signer: Account, realmId: number, from_coord: bigint, from_dir: number, generator_name: string, generator_value: number): Promise<boolean> => {
    let success = false

    try {
      const args = [realmId.toString(), from_coord.toString(), from_dir.toString(), stringToFelt(generator_name), generator_value.toString()]
      // console.log(args)
      const tx = await execute(signer, 'mint_chamber', 'mint_realms_chamber', args)


      console.log(`mint_realms_chamber tx:`, tx)

      const receipt = await signer.waitForTransaction(tx.transaction_hash, { retryInterval: 200 })
      console.log(`mint_realms_chamber receipt:`, receipt)
      success = getReceiptStatus(receipt)

      setComponentsFromEvents(contractComponents, getEvents(receipt));

    } catch (e) {
      console.log(`mint_realms_chamber exception:`, e)
    } finally {
    }

    return success
  }

  return {
    mint_realms_chamber,
  }
}

export function getReceiptStatus(receipt: any): boolean {
  if (receipt.execution_status == 'REVERTED') {
    console.error(`Transaction reverted:`, receipt.revert_reason)
    return false
  } else if (receipt.execution_status != 'SUCCEEDED') {
    console.error(`Transaction error [${receipt.execution_status}]:`, receipt)
    return false
  }
  return true
}
