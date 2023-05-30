import redTibbyToken from "./rTT.cdc"
import FungibleToken from "./FTstandard.cdc"

transaction () {

    let VaultAccess: &redTibbyToken.Vault?

    let VaultCapability: Capability<&redTibbyToken.Vault{FungibleToken.Balance, FungibleToken.Receiver}>

    prepare (signer: AuthAccount) {

        self.VaultAccess =  signer.borrow<&redTibbyToken.Vault>(from: redTibbyToken.VaultStoragePath)
        self.VaultCapability = signer.getCapability<&redTibbyToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, redTibbyToken.adminAccess}>(/public/rTT)

        var condition = self.VaultAccess.getType().identifier == "A.02.redTibbyToken.Vault" ? true : false

        // Check if a redTibbyToken Vault exists

        switch condition {

            // if it exists
            case true:

                 // check if it is properly set up  and fix it if otherwise
                switch self.VaultCapability.check() {

                case true : 
                    log("Vault is set up properly")
            

                case false : 
                    signer.link<&redTibbyToken.Vault{FungibleToken.Receiver, FungibleToken.Balance, redTibbyToken.adminAccess}>(/public/rTT, target: redTibbyToken.VaultStoragePath)
                }


            // otherwise create a new Vault and sets it up properly
            case false :
                let newVault <- redTibbyToken.createEmptyVault() as! @redTibbyToken.Vault
                signer.save<@redTibbyToken.Vault>(<- newVault, to: redTibbyToken.VaultStoragePath)
                signer.link<&redTibbyToken.Vault{FungibleToken.Receiver, FungibleToken.Balance, redTibbyToken.adminAccess}>(/public/rTT, target: redTibbyToken.VaultStoragePath)

        }
    }

    execute {
        log(" rTT vault set-up correctly")
    }

}
 
