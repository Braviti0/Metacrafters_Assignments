import FungibleToken from "../contracts/FTstandard.cdc"
import redTibbyToken from "../contracts/rTT.cdc"
import FlowToken from "../contracts/FlowToken.cdc"
import SwapperContract from "../contracts/Swapper.cdc"

transaction (amount: UFix64) {
    let swapper: &SwapperContract.Swapper
    let flowVault: &FungibleToken.Vault
    let rTTVault: &redTibbyToken.Vault{FungibleToken.Receiver}
    prepare (signer: AuthAccount) {

        self.swapper = signer.borrow<&SwapperContract.Swapper>(from: /storage/rttSwapper) ?? panic ("mint a swapper first")

        self.flowVault = signer.borrow<&FlowToken.Vault>(from: /storage/flowToken) ?? panic("You do not have a flow Vault")

        self.rTTVault = signer.borrow<&redTibbyToken.Vault>(from: redTibbyToken.VaultStoragePath) ?? panic("You do not have a rTT Vault")
    }

    execute {
        self.rTTVault.deposit(from:<- self.swapper.Swap(from: self.flowVault, amount: amount))
    }
}