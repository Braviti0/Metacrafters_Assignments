import FungibleToken from "./FTstandard.cdc"

pub fun main(user: Address): {Type: [UInt64]} {
  let answer: {Type: [UInt64]} = {}
  let authAccount: AuthAccount = getAuthAccount(user)
  
  let iterationFunction = fun (path: StoragePath, type: Type): Bool {
    // `isSubtype` is a function we can call on a Type to check if its parent
    // type is what we provide as the `of` parameter. In this case, we're essentially
    // saying, "if the current type of what we're looking at is a `@NonFungibleToken.Collection`,
    // then...
    if type.isSubtype(of: Type<@FungibleToken.Vault>()) {
        // We can borrow a broader `&NonFungibleToken.Collection` type here because we know
        // the type actually stored here is, in fact, a `@NonFungibleToken.Collection`. We will
        // be restricted to the functions defined inside of the `NonFungibleToken` contract, but
        // that's okay.
        let Vault = authAccount.borrow<&FungibleToken.Vault>(from: path)! // we can force-unwrap here because we know it exists
        let balance: UFix64= Vault.balance
        answer[type] = collectionIDs
    }

    return true
  }

  authAccount.forEachStored(iterationFunction)

  return answer
}
 