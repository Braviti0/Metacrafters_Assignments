import FlowToken from "./FlowToken.cdc"
import FungibleToken from "./FTstandard.cdc"

transaction () {

    let VaultAccess: &FlowToken.Vault?

    let VaultCapability0: Capability<&FlowToken.Vault{FungibleToken.Balance}>
    let VaultCapability1: Capability<&FlowToken.Vault{FungibleToken.Receiver}>

    prepare (signer: AuthAccount) {

        self.VaultAccess =  signer.borrow<&FlowToken.Vault>(from: /storage/flowToken)
        self.VaultCapability0 = signer.getCapability<&FlowToken.Vault{FungibleToken.Balance}>(/public/flowTokenBalance)
        self.VaultCapability1 = signer.getCapability<&FlowToken.Vault{FungibleToken.Receiver}>(/public/flowTokenReceiver)

        var Capabilitycondition = (self.VaultCapability0.check() && self.VaultCapability1.check()) ? 11 
                                            : !self.VaultCapability0.check() && !self.VaultCapability1.check() ? 00 
                                            : !self.VaultCapability0.check() && self.VaultCapability1.check() ? 01
                                            : 10

        var Vaultcondition = self.VaultAccess.getType().identifier == "A.01.FlowToken.Vault" ? true : false

        // Check if a Flow Token Vault exists

        switch Vaultcondition {

            // if it exists
            case true:

                 // check if it is properly set up  and fix it if otherwise
                switch Capabilitycondition {

                case 11 : 
                    log("Vault is set up properly")
            
                case 00 : 
                    signer.link<&FlowToken.Vault{FungibleToken.Balance}>(/public/flowTokenBalance, target: /storage/flowToken)
                    signer.link<&FlowToken.Vault{FungibleToken.Receiver}>(/public/flowTokenReceiver, target: /storage/flowToken)
                
                case 10 :
                    signer.link<&FlowToken.Vault{FungibleToken.Receiver}>(/public/flowTokenReceiver, target: /storage/flowToken)
                case 01 :
                    signer.link<&FlowToken.Vault{FungibleToken.Balance}>(/public/flowTokenBalance, target: /storage/flowToken) 

                }


            // otherwise create a new Vault and sets it up properly
            case false :
                let newVault <- FlowToken.createEmptyVault() as! @FlowToken.Vault
                signer.save<@FlowToken.Vault>(<- newVault, to: /storage/flowToken)
                signer.link<&FlowToken.Vault{FungibleToken.Balance}>(/public/flowTokenBalance, target: /storage/flowToken)
                signer.link<&FlowToken.Vault{FungibleToken.Receiver}>(/public/flowTokenReceiver, target: /storage/flowToken)

        }
    }

    execute {
        log("flow vault set up correctly")
    }

}
 
