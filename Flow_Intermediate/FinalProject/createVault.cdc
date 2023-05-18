import redTibbyToken from "./rTT.cdc"
import FungibleToken from "./FTstandard.cdc"

transaction () {

    prepare (signer: AuthAccount) {
        let newVault <- redTibbyToken.createEmptyVault() as! @redTibbyToken.Vault
        signer.save<@redTibbyToken.Vault>(<- newVault, to: /storage/rTT)

        signer.link<&redTibbyToken.Vault{FungibleToken.Receiver, FungibleToken.Balance}>(/public/rTT, target: /storage/rTT)
    }

}
 