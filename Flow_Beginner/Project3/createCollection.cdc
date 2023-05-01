import CryptoPoops from "./Project3c.cdc"
import NonFungibleToken from "./nftStandard.cdc"

transaction() {
  prepare(signer: AuthAccount) {
    // Store a `CryptoPoops.Collection` in our account storage.
    signer.save(<- CryptoPoops.createEmptyCollection(), to: /storage/MyCollection)
    
    // NOTE: We expose `&CryptoPoops.Collection{CryptoPoops.CollectionPublic}`, which 
    // only contains `deposit` and `getIDs`.
    signer.link<&CryptoPoops.Collection{CryptoPoops.CollectionPublic, NonFungibleToken.CollectionPublic}>(/public/MyCollection, target: /storage/MyCollection)
    log("Created Collection Successfully")
  }
}

 