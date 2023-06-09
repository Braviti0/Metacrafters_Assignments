import redTibbyToken from "../contracts/rTT.cdc"
import FungibleToken from "../contracts/FTstandard.cdc"

transaction () {

    prepare (signer: AuthAccount) {
        signer.unlink(/public/flowToken)
        signer.link<&redTibbyToken.Vault{FungibleToken.Receiver, FungibleToken.Balance, redTibbyToken.adminAccess}>(/public/rTT, target: redTibbyToken.VaultStoragePath)
    }

    execute {
        log("link rTT successfully")
    }
}
 