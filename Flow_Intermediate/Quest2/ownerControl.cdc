import House from "House.cdc"

transaction() {
    prepare (signer: AuthAccount) {
        var Home = signer.borrow<&House.Home>(from: /storage/home) ?? panic("You do not own a home")

        Home.CloseGate()
        Home.CloseMainDoor()

    }
}