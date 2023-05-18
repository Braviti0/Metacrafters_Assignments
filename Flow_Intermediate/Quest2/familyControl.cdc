 import House from "./House.cdc"

 transaction () {
    prepare (signer: AuthAccount) {
        var permit  = signer.borrow<&House.Family>(from: /storage/family) ?? panic("You do not have a family resource")

        var permission = (permit.Proxy?.borrow() ?? panic("You do not have access to a home")) ??  panic("error")

        permission.CloseGate()
        permission.CloseMainDoor()
    }
 }