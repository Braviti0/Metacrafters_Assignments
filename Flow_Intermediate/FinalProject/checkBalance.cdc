import redTibbyToken from "./rTT.cdc"
import FungibleToken from "./FTstandard.cdc"

pub fun main (_address: Address): UFix64 {
    let Vault = getAuthAccount(_address).borrow<&redTibbyToken.Vault>(from: /storage/rTT) ?? panic("the address does not have a vault")
    return Vault.balance
}