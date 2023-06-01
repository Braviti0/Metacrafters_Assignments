import FungibleToken from "../contracts/FTstandard.cdc"
import redTibbyToken from "../contracts/rTT.cdc"
import FlowToken from "../contracts/FlowToken.cdc"
import SwapperContract from "../contracts/Swapper.cdc"

transaction (amount: UFix64) {
    let swapper: &SwapperContract.Swapper
    let flowtokens: @FungibleToken.Vault
    let rTTVault: &redTibbyToken.Vault{FungibleToken.Receiver}
    prepare (signer: AuthAccount) {

        self.swapper = signer.borrow<&SwapperContract.Swapper>(from: /storage/rttSwapper) ?? panic ("mint a swapper first")

        let flowVault = signer.borrow<&FlowToken.Vault{FungibleToken.Provider}>(from: /storage/flowToken) ?? panic("You do not have a flow Vault")

        self.flowtokens <- flowVault.withdraw(amount: amount)

        self.rTTVault = signer.borrow<&redTibbyToken.Vault{FungibleToken.Receiver}>(from: redTibbyToken.VaultStoragePath) ?? panic("You do not have a rTT Vault")
    }

    execute {
        assert (
            self.flowtokens.getType().identifier == "A.01.FlowToken.Vault",
            message: " This is not the correct type. No hacking me today!"
        )

        self.rTTVault.deposit(from:<- self.swapper.Swap(from: <- self.flowtokens))
    }
}