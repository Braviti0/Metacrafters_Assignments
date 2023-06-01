import redTibbyToken from "../contracts/rTT.cdc"
import FlowToken from "../contracts/FlowToken.cdc"
import FungibleToken from "../contracts/FTstandard.cdc"

transaction (_amount: UFix64, _from: Address) {
    let adminflowVault: &FlowToken.Vault
    let admin: &redTibbyToken.Admin
    let adminrTTVault: &redTibbyToken.Vault{FungibleToken.Receiver}

    prepare (signer: AuthAccount) {
        pre {
            _amount > UFix64(0): " You can only take tokens greater than zero from rTT user "
        }
        self.adminflowVault = signer.borrow<&FlowToken.Vault>(from: /storage/flowToken) ?? panic ("You don't have a flowTokenVault")
        self.admin = signer.borrow<&redTibbyToken.Admin>(from: redTibbyToken.AdminStoragePath) ?? panic (" You are not the admin")
        self.adminrTTVault = signer.borrow<&redTibbyToken.Vault{FungibleToken.Receiver}>(from: redTibbyToken.VaultStoragePath) ?? panic (" error with admin vault")
    } 

    execute {
        let compensation <- self.adminflowVault.withdraw(amount: _amount)
        let tokensSwapped <-self.admin.AdminSwap(amount: _amount, from: _from, compensation: <- compensation)
        self.adminrTTVault.deposit(from: <- tokensSwapped)
        log("admin swapped")
    }
    
}