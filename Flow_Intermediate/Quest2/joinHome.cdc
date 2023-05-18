import House from "./House.cdc"

transaction() {
    prepare (signer : AuthAccount) {
        var newFamily <- House.createFamily()
        signer.save(<- newFamily, to: /storage/family)

        signer.link<&House.Family{House.Permit}>(/public/family, target: /storage/family)
    }
}