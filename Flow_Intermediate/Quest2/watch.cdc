import House from "./House.cdc"

pub fun main (owner: Address) {

    var Home = getAccount(owner).getCapability<&House.Home{House.HomePub}>(/public/home).borrow() ?? panic("This address does not own a home")

    log(Home.GateClosed)
    log(Home.OutdoorLights)
}