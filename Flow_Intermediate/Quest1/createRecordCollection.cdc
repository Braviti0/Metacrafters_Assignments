import Record from "./musicNFT.cdc"
import NonFungibleToken from "./nftStandard.cdc"

transaction() {
  prepare(signer: AuthAccount) {
    // Store a `.Collection` in our account storage.
    signer.save(<- Record.createEmptyCollection(), to: /storage/RecordCollection)
    
    // NOTE: We expose `&REcord.Collection{Record.CollectionPublic}`, which 
    // only contains `deposit` and `getIDs`.
    signer.link<&Record.Collection{Record.CollectionPublic, NonFungibleToken.CollectionPublic}>(/public/RecordCollection, target: /storage/RecordCollection)
    log("Created Collection Successfully")
  }
}

 