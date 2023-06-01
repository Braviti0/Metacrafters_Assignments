import FungibleToken from "../contracts/FTstandard.cdc"

pub fun main(user: Address):  {Type: data} {

  let answer: {Type: data} = {}

  let authAccount: AuthAccount = getAuthAccount(user)
  
  let iterationFunction = fun (path: StoragePath, type: Type): Bool {

    if type.isSubtype(of: Type<@FungibleToken.Vault>()) {
        let Vault = authAccount.borrow<&FungibleToken.Vault>(from: path)! // we can force-unwrap here because we know it exists
        let balance: UFix64= Vault.balance
        let id: String = Vault.getType().identifier
        answer[type] = data(balance , id)
    }
    return true
  }

  authAccount.forEachStored(iterationFunction)

  log("will return all fungible tokens")
  log(answer)
  return answer

}

pub struct data{
  pub let id: String
  pub let balance: UFix64

  init (_ balance: UFix64, _ id: String) {
  self.id = id
  self.balance = balance
  }
}

 