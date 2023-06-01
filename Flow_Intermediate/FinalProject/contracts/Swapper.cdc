import FungibleToken from "./FTstandard.cdc"
import redTibbyToken from "./rTT.cdc"
import FlowToken from "./FlowToken.cdc"

pub contract SwapperContract {

    pub event Swapped (flowAmount: UFix64, rTTAmount: UFix64 , by: Address)

    pub resource Swapper{
        init() {}

        pub fun Swap (from: @FungibleToken.Vault): @FungibleToken.Vault {
            assert (
                from.getType().identifier == "A.01.FlowToken.Vault",
                message: " This is not the correct type. No hacking me today!"
            )

            let receivedTokens = from.balance
            let pool = SwapperContract.account.borrow<&FlowToken.Vault{FungibleToken.Receiver}>(from: /storage/flowTokenVault) ?? panic("Internal error")
            pool.deposit(from: <- from)
            let minter = SwapperContract.account.borrow<&redTibbyToken.Admin>(from: redTibbyToken.AdminStoragePath) ?? panic("Swapper Contract must be deployed to rTT Admin address")
            return <- minter.mint(amount: 2.0 * receivedTokens)
        }

    }

    pub fun mintSwapper() :@Swapper{
        return <- create Swapper()
    }

    init() {
        let signer = self.account
        let VaultAccess =  signer.borrow<&FlowToken.Vault>(from: /storage/flowToken)
        let VaultCapability0 = signer.getCapability<&FlowToken.Vault{FungibleToken.Balance}>(/public/flowTokenBalance)
        let VaultCapability1 = signer.getCapability<&FlowToken.Vault{FungibleToken.Receiver}>(/public/flowTokenReceiver)

        var Capabilitycondition = (VaultCapability0.check() && VaultCapability1.check()) ? 11 
                                            : !VaultCapability0.check() && !VaultCapability1.check() ? 00 
                                            : !VaultCapability0.check() && VaultCapability1.check() ? 01
                                            : 10

        var Vaultcondition = VaultAccess.getType().identifier == "A.01.FlowToken.Vault" ? true : false

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
}