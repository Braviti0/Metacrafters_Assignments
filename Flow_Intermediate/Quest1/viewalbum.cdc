import Record from "./musicNFT.cdc"
import Artist from "./artistProfile.cdc"
import NonFungibleToken from "./nftStandard.cdc"

pub fun main (User: Address): [UInt64] {

    // Get a reference to the Artists Profile
    let ArtistProfile = getAccount(User).getCapability(/public/Profile).borrow<&Artist.Profile>()
                                  ?? panic("The recipient does not have a Collection.")

    // Get the capability to the Artists album
    let album = ArtistProfile.recordCollection.borrow() ?? panic ("Artist has no album")

    // Get the ids of the nfts in the album
    let NFTs = album.getIDs()

    return NFTs

}