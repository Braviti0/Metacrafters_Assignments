import redTibbyToken from "./rTT.cdc"
import FungibleToken from "./FTstandard.cdc"

transaction (amount: UFix64, receipient: Address) {

    let minter: &redTibbyToken.Admin
    let receiver: &redTibbyToken.Vault{FungibleToken.Receiver}

    prepare (signer: AuthAccount) {
        self.minter = signer.borrow<&redTibbyToken.Admin>(from:redTibbyToken.AdminStoragePath) ?? panic ("You are not the rTT admin")
        self.receiver = getAccount(receipient).getCapability<&redTibbyToken.Vault{FungibleToken.Receiver}>(/public/rTT).borrow() ?? panic ("Error, Check your receiver's rTT Vault status")
    }

    execute {
        let tokens <- self.minter.mint(amount: amount)
        self.receiver.deposit(from: <- tokens)
        log("mint rTT tokens successfully")
        log(amount.toString().concat(" Tokens minted"))
    }
}