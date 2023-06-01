import redTibbyToken from "../contracts/rTT.cdc"
import FungibleToken from "../contracts/FTstandard.cdc"

transaction () {
    let vaultCapability: Capability<&redTibbyToken.Vault{FungibleToken.Balance}>
  
    prepare(signer: AuthAccount) {
        self.vaultCapability = signer.getCapability<&redTibbyToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, redTibbyToken.adminAccess}>(/public/rTT)
    
    }

    execute {
        log("rTT Vault set up correctly? T/F")
        log(self.vaultCapability.check())
    }
}
