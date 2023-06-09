import FungibleToken from "../contracts/FTstandard.cdc"
import redTibbyToken from "../contracts/rTT.cdc"

transaction () {

    let VaultAccess: &redTibbyToken.Vault?

    let VaultCapability: Capability<&redTibbyToken.Vault{FungibleToken.Balance, FungibleToken.Receiver}>

    prepare (signer: AuthAccount) {

        self.VaultAccess =  signer.borrow<&redTibbyToken.Vault>(from: redTibbyToken.VaultStoragePath)
        self.VaultCapability = signer.getCapability<&redTibbyToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, redTibbyToken.adminAccess}>(/public/rTT)

        var condition = (self.VaultAccess.getType() == Type<&redTibbyToken.Vault?>()) ? true  : false

        if condition {
            if self.VaultCapability.check() {
                log("Vault is set up properly")
            } else {
                signer.unlink(/public/rTT)
                signer.link<&redTibbyToken.Vault{FungibleToken.Receiver, FungibleToken.Balance, redTibbyToken.adminAccess}>(/public/rTT, target: redTibbyToken.VaultStoragePath)
            }   
        } else {
                let newVault <- redTibbyToken.createEmptyVault()
                signer.unlink(/public/rTT)
                signer.save(<- newVault, to: redTibbyToken.VaultStoragePath)
                signer.link<&redTibbyToken.Vault{FungibleToken.Receiver, FungibleToken.Balance, redTibbyToken.adminAccess}>(/public/rTT, target: redTibbyToken.VaultStoragePath)
        }
    }

    execute {
        log(" rTT vault set-up correctly")
    }

}
 
