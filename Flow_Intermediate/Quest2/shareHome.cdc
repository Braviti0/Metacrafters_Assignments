import House from "./House.cdc"

transaction (Family: Address) {
    prepare (signer: AuthAccount) {
        var permit = signer.getCapability<&House.Home>(/private/home)

        var relative = getAccount(Family).getCapability<&House.Family{House.Permit}>(/public/family).borrow() ?? panic("This account does not have a family resource")

        relative.depositPermit(Proxy: permit)
    }
}