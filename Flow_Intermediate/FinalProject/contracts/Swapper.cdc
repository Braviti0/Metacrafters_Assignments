import FungibleToken from "./FTstandard.cdc"
import redTibbyToken from "./rTT.cdc"
import FlowToken from "./FlowToken.cdc"

pub contract SwapperContract {

    pub event Swapped (flowAmount: UFix64, rTTAmount: UFix64 , by: Address)

    pub resource Swapper{
        init() {}

        pub fun Swap (from: &FungibleToken.Vault, amount: UFix64): @FungibleToken.Vault {

            let pool = SwapperContract.account.borrow<&FlowToken.Vault>(from: /storage/flowToken) ?? panic("Swapper account must have a flow Vault")
            
            pool.deposit(from: <- from.withdraw(amount: amount))
            let minter = SwapperContract.account.borrow<&redTibbyToken.Admin>(from: redTibbyToken.AdminStoragePath) ?? panic("Swapper Contract must be deployed to rTT Admin address")
            return <- minter.mint(amount: 2.0 * amount)
        }

    }

    pub fun mintSwapper() :@Swapper{
        return <- create Swapper()
    }

    init() {
        let signer = self.account
}

}
