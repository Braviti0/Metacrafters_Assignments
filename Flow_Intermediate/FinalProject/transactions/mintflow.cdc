import FungibleToken from "../contracts/FTstandard.cdc"
import FlowToken from "../contracts/FlowToken.cdc"

transaction (amount: UFix64, receipient: Address) {
    let minter : &FlowToken.Minter
    let receiver : &FlowToken.Vault{FungibleToken.Receiver}

    prepare (signer:AuthAccount) {
        self.minter = signer.borrow<&FlowToken.Minter>(from: /storage/flowTokenMinter) ?? panic("Admin has not permitted you to mint")
        self.receiver = getAccount(receipient).getCapability<&FlowToken.Vault{FungibleToken.Receiver}>(/public/flowToken).borrow() ?? panic("Receiver does not have a flow token vault")
    }

    execute {
        let minted <-self.minter.mintTokens(amount: amount)
        self.receiver.deposit(from: <- minted)
        log("flow minted")
    }
}