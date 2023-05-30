import redTibbyToken from "./rTT.cdc"
import FungibleToken from "./FTstandard.cdc"
import FlowToken from "./FlowToken.cdc"

pub fun main (_address: Address): [Wallet] {

  let Vaults : [Wallet] = []

  let account: AuthAccount = getAuthAccount(_address)

  // the other way to make sure the vault is the correct type is implemented here, we simply borrow a redTibby Token instead of an AnyResource type
  let rTTVault = account.borrow<&redTibbyToken.Vault>(from: redTibbyToken.VaultStoragePath) ?? panic("the address does not have a rTT vault")
  let flowVault = account.borrow<&FlowToken.Vault>(from: /storage/flowToken) ?? panic("the address does not have a flow vault")


  // makes sure the vault is the correct type (redTibbyToken)
  assert(
    rTTVault.getType().identifier == "A.02.redTibbyToken.Vault",
    message: "This is not the correct type. No hacking me today!"
  )

  assert (
    flowVault.getType().identifier == "A.01.FlowToken.Vault",
    message: " This is not the correct type. No hacking me today!"
  )
      

  account.unlink(/public/rTT)
  account.link<&redTibbyToken.Vault{FungibleToken.Balance}>(/public/rTT, target: redTibbyToken.VaultStoragePath)
  let rTTwallet = getAccount(_address).getCapability<&redTibbyToken.Vault{FungibleToken.Balance}>(/public/rTT).borrow() ?? panic ("error0")
  Vaults[0] = Wallet("redTibbyToken", rTTwallet.balance)

  account.unlink(/public/flowTokenBalance)
  account.link<&FlowToken.Vault{FungibleToken.Balance}>(/public/flowTokenBalance, target: /storage/flowToken)
  let flowwallet = getAccount(_address).getCapability<&FlowToken.Vault{FungibleToken.Balance}>(/public/flowTokenBalance).borrow() ?? panic("error1")
  Vaults[1] = Wallet("Flow Token", flowwallet.balance)

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