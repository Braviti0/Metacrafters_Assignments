import FungibleToken from "../contracts/FTstandard.cdc"
import FlowToken from "../contracts/FlowToken.cdc"

transaction () {

    let VaultAccess: &FlowToken.Vault?

    let VaultCapability: Capability<&FlowToken.Vault{FungibleToken.Receiver, FungibleToken.Balance}>

    prepare (signer: AuthAccount) {

        self.VaultAccess =  signer.borrow<&FlowToken.Vault>(from: /storage/flowToken)
        self.VaultCapability = signer.getCapability<&FlowToken.Vault{FungibleToken.Receiver, FungibleToken.Balance}>(/public/flowToken)

        var Vaultcondition = (self.VaultAccess.getType() == Type<&FlowToken.Vault?>()) ? true  : false

        // Check if a Flow Token Vault exists

        if Vaultcondition {
            if self.VaultCapability.check() {
                log("Vault is set up properly")
            } else {
                        signer.unlink(/public/flowToken)
                        signer.link<&FlowToken.Vault{FungibleToken.Receiver, FungibleToken.Balance}>(/public/flowToken, target: /storage/flowToken)
            }
            
        } else {
                let newVault <- FlowToken.createEmptyVault()
                signer.save(<- newVault, to: /storage/flowToken)
                signer.unlink(/public/flowToken)
                signer.link<&FlowToken.Vault{FungibleToken.Balance, FungibleToken.Receiver}>(/public/flowToken, target: /storage/flowToken)
        }
    }

    execute {
        log("flow vault set up correctly")
    }

 
}