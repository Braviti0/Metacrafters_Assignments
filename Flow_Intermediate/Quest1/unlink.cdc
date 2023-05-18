import Record from "./musicNFT.cdc"
import NonFungibleToken from "./nftStandard.cdc"

transaction() {
  prepare(signer: AuthAccount) {
    

    signer.unlink(/public/RecordCollection)
    log("Unlink Collection Successfully")
  }
}

 