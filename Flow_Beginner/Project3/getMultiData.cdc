import CryptoPoops from "./Project3c.cdc"

pub fun main(account: Address, id: UInt64): Data {
  let CryptoPoopsCollection = getAccount(account).getCapability(/public/gsasm)
                        .borrow<&CryptoPoops.Collection{CryptoPoops.CollectionPublic}>()
                        ?? panic("Could not borrow the Collection from the account.")
  let CryptoPoops = CryptoPoopsCollection.borrowNFT(id: id) as! &CryptoPoops.NFT?
  return Data(CryptoPoops, CryptoPoops!.name)
}

pub struct Data {
  pub let CryptoPoops: &CryptoPoops.NFT?
  pub let name: String

  init(_ CryptoPoops: &CryptoPoops.NFT?, _ name: String) {
    self.CryptoPoops = CryptoPoops
    self.name = name
  }
}
