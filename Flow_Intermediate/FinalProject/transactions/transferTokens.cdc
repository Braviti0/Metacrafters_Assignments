import FungibleToken from "../contracts/FTstandard.cdc"
import redTibbyToken from "../contracts/rTT.cdc"
import FlowToken from "../contracts/FlowToken.cdc"

transaction(recipient: Address, amount: UFix64) {

  // Local variables
  let Vault: &redTibbyToken.Vault
  let RecipientVault: &redTibbyToken.Vault{FungibleToken.Receiver}

  prepare(signer: AuthAccount) {
    // Borrow signer's `&redtibby.Vault`
    self.Vault = signer.borrow<&redTibbyToken.Vault>(from: redTibbyToken.VaultStoragePath) ?? panic ("You do not own a Vault")
    // Borrow recipient's `&redtibby.Vault{FungibleToken.Receiver}`
    self.RecipientVault = getAccount(recipient).getCapability(/public/rTT)
              .borrow<&redTibbyToken.Vault{FungibleToken.Receiver}>() ?? panic ("The receipient does not own a vault")
  }

  // All execution
  execute {
    let tokens <- self.Vault.withdraw(amount: amount)
    self.RecipientVault.deposit(from: <- tokens)

    log ("transfer succesfully")
    log(amount.toString().concat(" transferred to"))
    log(recipient)
  }
}
