import Record from "./musicNFT.cdc"
import NonFungibleToken from "./nftStandard.cdc"

transaction(name: String) {

  prepare(signer: AuthAccount) {

    // Get a reference to the `recipient`s public Collection
    let recipientsCollection = getAccount(signer.address).getCapability(/public/RecordCollection)
                                  .borrow<&Record.Collection{Record.CollectionPublic}>()
                                  ?? panic("The recipient does not have a Collection.")

    // mint the NFT using the reference to the `Minter` and pass in the metadata
    let nft <- Record.createRecord(songName: name)

    // deposit the NFT in the recipient's Collection
    recipientsCollection.deposit(token: <- nft)

    log("mint successfully")
  }

}
 