import CryptoPoops from "./Project3c.cdc"
import NonFungibleToken from "./nftStandard.cdc"

pub fun main(User: Address) {

    // Get a reference to the User`s public Collection
    let recipientsCollection = getAccount(User).getCapability(/public/MyCollection)
                                  .borrow<&CryptoPoops.Collection{CryptoPoops.CollectionPublic}>()
                                  ?? panic("The recipient does not have a Collection.")

    // Get all the NFT IDs using
    var NFTs = recipientsCollection.getIDs()

    // log the NFT IDs
    log(NFTs)
}