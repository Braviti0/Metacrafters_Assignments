import Artist from "./artistProfile.cdc"
import Record from "./musicNFT.cdc"
import NonFungibleToken from "./nftStandard.cdc"

transaction(_name: String) {

  prepare(signer: AuthAccount) {

        // Get a reference to the signer`s public Collection
    let ArtistsCollection:Capability<&Record.Collection{Record.CollectionPublic}> = getAccount(signer.address).getCapability<&Record.Collection{Record.CollectionPublic}>(/public/RecordCollection)

    // mint the Profile using the reference to the `Minter` and pass in the metadata
    let Profile <- Artist.createProfile(name: _name, recordCollection: ArtistsCollection)

    // Store a `.Collection` in our account storage.
    signer.save(<- Profile, to: /storage/Profile)

    signer.link<&Artist.Profile>(/public/Profile, target: /storage/Profile)

    log("created Profile successfully")
  }

}
 