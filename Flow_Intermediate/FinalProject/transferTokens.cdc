import redTibbyToken from "./rTT.cdc"
import FungibleToken from "./FTstandard.cdc"

transaction(recipient: Address, amount: UFix64) {

  // Local variables
  let Vault: &redTibbyToken.Vault
  let RecipientVault: &redTibbyToken.Vault{FungibleToken.Receiver}

  prepare(signer: AuthAccount) {
    // Borrow signer's `&FlowToken.Vault`
    self.Vault = signer.borrow<&redTibbyToken.Vault>(from: /storage/rTT) ?? panic ("You do not own a Vault")
    // Borrow recipient's `&FlowToken.Vault{FungibleToken.Receiver}`
    self.RecipientVault = getAccount(recipient).getCapability(/public/rTT)
              .borrow<&redTibbyToken.Vault{FungibleToken.Receiver}>() ?? panic ("The receipient does not own a vault")
  }

  // All execution
  execute {
    let tokens <- self.Vault.withdraw(amount: amount)
    self.RecipientVault.deposit(from: <- tokens)
  }
}
