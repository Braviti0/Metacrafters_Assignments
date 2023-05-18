 import NonFungibleToken from "./nftStandard.cdc"

pub contract Record: NonFungibleToken {

    pub var totalSupply: UInt64

    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)

    pub let CollectionStoragePath: StoragePath
    pub let CollectionPublicPath: PublicPath

    pub resource NFT: NonFungibleToken.INFT {
        pub let id: UInt64
        pub let songName: String
    
        init(songName: String) {
            self.id = self.uuid
            self.songName = songName
            Record.totalSupply = Record.totalSupply + 1
        }
    }

    pub resource interface CollectionPublic {
        pub fun deposit(token: @NonFungibleToken.NFT)
        pub fun getIDs(): [UInt64]
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT
        pub fun borrowRecordNFT(id: UInt64): &Record.NFT? {
            post {
                (result == nil) || (result?.id == id):
                    "Cannot borrow the reference: the ID of the returned reference is incorrect"
            }
        }
    }

    pub resource Collection: CollectionPublic, NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic {
        pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
            let token <- self.ownedNFTs.remove(key: withdrawID) ?? panic("missing NFT")
            emit Withdraw(id: token.id, from: self.owner?.address)
            return <- token
        }

        pub fun deposit(token: @NonFungibleToken.NFT) {
            let token <- token as! @Record.NFT
            emit Deposit(id: token.uuid, to: self.owner?.address)
            self.ownedNFTs[token.uuid] <-! token
        }

        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
            return (&self.ownedNFTs[id] as &NonFungibleToken.NFT?)!
        }
 
        pub fun borrowRecordNFT(id: UInt64): &Record.NFT? {
            if self.ownedNFTs[id] != nil {
                let ref = (&self.ownedNFTs[id] as auth &NonFungibleToken.NFT?)!
                return ref as! &Record.NFT
            }

            return nil
        }

        init () {
            self.ownedNFTs <- {}
        }

        destroy() {
            destroy self.ownedNFTs
        }
    }

    pub fun createEmptyCollection(): @NonFungibleToken.Collection {
        return <- create Collection()
    }

    pub fun createRecord(songName: String): @NFT {
      return <- create NFT(songName: songName)
    }

    init() {
        self.totalSupply = 0

        self.CollectionStoragePath = /storage/RecordCollection
        self.CollectionPublicPath = /public/RecordCollection

        emit ContractInitialized()
    }
}
