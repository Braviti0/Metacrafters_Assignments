import FungibleToken from "../contracts/FTstandard.cdc"
import redTibbyToken from "../contracts/rTT.cdc"

pub fun main(_address: Address) {
    let vaultCapability= getAccount(_address).getCapability<&redTibbyToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, redTibbyToken.adminAccess}>(/public/rTT)

    log("rTT Vault set up correctly? T/F")
    log(vaultCapability.check())
}
