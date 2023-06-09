import FungibleToken from "../contracts/FTstandard.cdc"
import redTibbyToken from "../contracts/rTT.cdc"
import FlowToken from "../contracts/FlowToken.cdc"

pub fun main (_address: Address): [Wallet] {

  let Vaults : [Wallet] = []

  let account: AuthAccount = getAuthAccount(_address)

  // the other way to make sure the vault is the correct type is implemented here, we simply borrow a redTibby Token instead of an AnyResource type
  let rTTVault = account.borrow<&redTibbyToken.Vault>(from: redTibbyToken.VaultStoragePath) ?? panic("the address does not have a rTT vault")
  let flowVault = account.borrow<&FlowToken.Vault>(from: /storage/flowToken) ?? panic("the address does not have a flow vault")


  // makes sure the vault is the correct type (redTibbyToken)
  assert(
    rTTVault.getType() == Type<@redTibbyToken.Vault>(),
    message: "This is not the correct type. No hacking me today!"
  )

  assert (
    flowVault.getType() == Type<@FlowToken.Vault>(),
    message: " This is not the correct type. No hacking me today!"
  )
      

  account.unlink(/public/rTT)
  account.link<&redTibbyToken.Vault{FungibleToken.Balance}>(/public/rTT, target: redTibbyToken.VaultStoragePath)
  let rTTwallet = getAccount(_address).getCapability<&redTibbyToken.Vault{FungibleToken.Balance}>(/public/rTT).borrow() ?? panic ("error0")
  Vaults.append(Wallet("redTibbyToken", rTTwallet.balance))

  account.unlink(/public/flowToken)
  account.link<&FlowToken.Vault{FungibleToken.Balance}>(/public/flowToken, target: /storage/flowToken)
  let flowwallet = getAccount(_address).getCapability<&FlowToken.Vault{FungibleToken.Balance}>(/public/flowToken).borrow() ?? panic("error1")
  Vaults.append(Wallet("Flow Token", flowwallet.balance))

  log("will return flow and rTT token data as structs")
  log(Vaults)
  return Vaults
}

pub struct Wallet {
  pub let tokenName: String
  pub let tokenBalance: UFix64

  init (_ name: String, _ balance: UFix64){
    self.tokenName = name
    self.tokenBalance = balance
  }
}