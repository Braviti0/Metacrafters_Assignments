import House from "./House.cdc"

transaction() {
    prepare (signer : AuthAccount) {
        var newHouse <- House.createHome()
        signer.save(<- newHouse, to: /storage/home)

        signer.link<&House.Home{House.HomePub}>(/public/home, target: /storage/home)

        signer.link<&House.Home>(/private/home, target: /storage/home)
    }
}