import Record from "./musicNFT.cdc"

pub contract Artist {

  pub resource Profile {
    pub let id: UInt64
    pub let name: String
    pub let recordCollection: Capability<&Record.Collection{Record.CollectionPublic}>

    init(name: String, recordCollection: Capability<&Record.Collection{Record.CollectionPublic}>) {
      self.id = self.uuid
      self.name = name
      self.recordCollection = recordCollection
    }
  }

  pub fun createProfile(name: String, recordCollection: Capability<&Record.Collection{Record.CollectionPublic}>): @Profile {
    return <- create Profile(name: name, recordCollection: recordCollection)
  }

}
