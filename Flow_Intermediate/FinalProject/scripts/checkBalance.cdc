import FungibleToken from "../contracts/FTstandard.cdc"
import redTibbyToken from "../contracts/rTT.cdc"
import FlowToken from "../contracts/FlowToken.cdc"

pub fun main (_address: Address): UFix64 {

      let account: AuthAccount = getAuthAccount(_address)

    // the other way to make sure the vault is the correct type is implemented here, we simply borrow a redTibby Token instead of an AnyResource type
    let Vault = account.borrow<&redTibbyToken.Vault>(from: redTibbyToken.VaultStoragePath) ?? panic("the address does not have a vault")


    // I couldn't use the type identifier because of the buggy flow playground
    // otherwise the code would have been like:
    // Vault.getType().identifier == "A.02.redTibbyToken.Vault"
    // makes sure the vault is the correct type (redTibbyToken)
    assert(
        Vault.getType() == Type<@redTibbyToken.Vault>(),
        message: "This is not the correct type. No hacking me today!"
        )

      account.unlink(/public/rTT)
      account.link<&redTibbyToken.Vault{FungibleToken.Balance}>(/public/rTT, target: redTibbyToken.VaultStoragePath)
      let wallet = getAccount(_address).getCapability<&redTibbyToken.Vault{FungibleToken.Balance}>(/public/rTT).borrow() ?? panic ("error")


    log("will return Vault balance")
    log(wallet.balance)
    return wallet.balance
}









