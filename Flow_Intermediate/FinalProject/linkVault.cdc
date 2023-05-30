import redTibbyToken from "./rTT.cdc"
import FungibleToken from "./FTstandard.cdc"

transaction () {

    prepare (signer: AuthAccount) {
        signer.link<&redTibbyToken.Vault{FungibleToken.Receiver, FungibleToken.Balance, redTibbyToken.adminAccess}>(/public/rTT, target: /storage/rTT)
    }

    execute {
        log("link rTT successfully")
    }
}
 