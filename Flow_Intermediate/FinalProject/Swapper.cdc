import FungibleToken from "./FTstandard.cdc"
import redTibbyToken from "./rTT.cdc"
import FlowToken from "./FlowToken.cdc"

pub contract SwapperContract {

    pub event Swapped (flowAmount: UFix64, rTTAmount: UFix64 , by: Address)

    pub resource Swapper{
        init() {}

        pub fun Swap (from: @FungibleToken.Vault): @FungibleToken.Vault {

            let receivedTokens = from.balance
            let pool = SwapperContract.account.borrow<&FlowToken.Vault{FungibleToken.Receiver}>(from: /storage/flowTokenVault) ?? panic("Internal error")
            pool.deposit(from: <- from)
            return redTibbyToken.mintTokens(amount: UFix64(2)* receivedTokens)
        }

    }

    pub fun mintSwapper() :@Swapper{
        return <- create Swapper()
    }

    init() {
        let newVault <- FlowToken.createEmptyVault() as! @FlowToken.Vault
        self.account.save(<-newVault, to: /storage/flowToken)
        self.account.link<&FlowToken.Vault{FungibleToken.Balance}>(/public/flowTokenBalance, target: /storage/flowTokenVault)
        self.account.link<&FlowToken.Vault{FungibleToken.Receiver}>(/public/flowTokenReceiver, target: /storage/flowTokenVault)
    }
}