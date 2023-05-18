import Record from "./musicNFT.cdc"
import NonFungibleToken from "./nftStandard.cdc"

pub fun main(User: Address): [UInt64] {

    // Get a reference to the User`s public Collection
    let recipientsCollection = getAccount(User).getCapability(/public/RecordCollection)
                                  .borrow<&Record.Collection{Record.CollectionPublic}>()
                                  ?? panic("The recipient does not have a Collection.")

    // get all the Record IDs
    var NFTs = recipientsCollection.getIDs()

    return NFTs

}