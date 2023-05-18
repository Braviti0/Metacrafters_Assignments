import FungibleToken from "./FTstandard.cdc"

pub contract redTibbyToken: FungibleToken {
    
    pub var totalSupply: UFix64

    pub var VaultStoragePath: StoragePath
    pub var AdminStoragePath: StoragePath

    /// The event that is emitted when the contract is created
    pub event TokensInitialized(initialSupply: UFix64)
z
    /// The event that is emitted when tokens are withdrawn from a Vault
    pub event TokensWithdrawn(amount: UFix64, from: Address?)

    /// The event that is emitted when tokens are deposited into a Vault
    pub event TokensDeposited(amount: UFix64, to: Address?)

    /// The event that is emitted when new tokens are minted
    pub event TokensMinted(amount: UFix64)

    /// The event that is emitted when a new minter resource is created
    pub event MinterCreated(allowedAmount: UFix64)

    pub resource Vault: FungibleToken.Provider, FungibleToken.Receiver, FungibleToken.Balance {
        pub var balance: UFix64

        init (balance: UFix64) {
            self.balance = balance
        }

        pub fun deposit(from: @FungibleToken.Vault) {
            let tempVault <- from as! @redTibbyToken.Vault
            self.balance = self.balance + tempVault.balance
            emit TokensDeposited(amount:tempVault.balance, to: self.owner?.address)
            tempVault.balance = 0.0
            destroy tempVault
        }

        pub fun withdraw(amount: UFix64) : @FungibleToken.Vault {
            self.balance = self.balance - amount
            emit TokensWithdrawn(amount: amount, from: self.owner?.address)
            let tempVault <-create Vault(balance: amount) as! @FungibleToken.Vault
            return <- tempVault
        }

        destroy() {
            if self.balance > 0.0 {
                redTibbyToken.totalSupply = redTibbyToken.totalSupply - self.balance
            }
        }

    }

    pub fun createEmptyVault(): @FungibleToken.Vault {
        let tempVault <- create Vault(balance: 0.0) as! @FungibleToken.Vault
        return <- tempVault
    }

     pub resource Admin {

        /// Function that creates and returns a new minter resource

        pub fun createNewMinter(allowedAmount: UFix64): @Minter {
            emit MinterCreated(allowedAmount: allowedAmount)
            return <-create Minter(allowedAmount: allowedAmount)
        }
    }

    /// Resource object that token admin accounts can hold to mint new tokens.
    ///
    pub resource Minter {

        /// The amount of tokens that the minter is allowed to mint
        pub var allowedAmount: UFix64

        /// Function that mints new tokens, adds them to the total supply,

        pub fun mintTokens(amount: UFix64): @redTibbyToken.Vault {
            pre {
                amount > 0.0: "Amount minted must be greater than zero"
                amount <= self.allowedAmount: "Amount minted must be less than the allowed amount"
            }
            redTibbyToken.totalSupply = redTibbyToken.totalSupply + amount
            self.allowedAmount = self.allowedAmount - amount
            emit TokensMinted(amount: amount)
            return <-create Vault(balance: amount)
        }

        init(allowedAmount: UFix64) {
            self.allowedAmount = allowedAmount
        }
    }



    init (totalSupply: UFix64) {
        self.totalSupply = totalSupply
        self.VaultStoragePath = /storage/rTTVault
        self.AdminStoragePath = /storage/rTTAdmin

        let vault <- create Vault(balance: self.totalSupply)
        self.account.save(<-vault, to: self.VaultStoragePath)

        let admin <- create Admin()
        self.account.save(<-admin, to: self.AdminStoragePath)

        emit TokensInitialized(initialSupply: totalSupply)
    }
}
 