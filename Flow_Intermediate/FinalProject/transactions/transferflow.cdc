import FungibleToken from "../contracts/FTstandard.cdc"
import redTibbyToken from "../contracts/rTT.cdc"
import FlowToken from "../contracts/FlowToken.cdc"

transaction(recipient: Address, amount: UFix64) {

  // Local variables
  let Vault: &FlowToken.Vault
  let RecipientVault: &FlowToken.Vault{FungibleToken.Receiver}

  prepare(signer: AuthAccount) {
    // Borrow signer's `&FlowToken.Vault`
    self.Vault = signer.borrow<&FlowToken.Vault>(from: /storage/flowToken) ?? panic ("You do not own a Vault")
    // Borrow recipient's `&FlowToken.Vault{FungibleToken.Receiver}`
    self.RecipientVault = getAccount(recipient).getCapability(/public/flowToken)
              .borrow<&FlowToken.Vault{FungibleToken.Receiver}>() ?? panic ("The receipient does not own a vault")
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
