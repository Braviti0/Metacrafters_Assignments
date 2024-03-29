import FungibleToken from "../contracts/FTstandard.cdc"
import redTibbyToken from "../contracts/rTT.cdc"
import FlowToken from "../contracts/FlowToken.cdc"

transaction () {
    let admin : &FlowToken.Administrator

    prepare (signer: AuthAccount) {
        self.admin = signer.borrow<&FlowToken.Administrator>(from: /storage/flowTokenAdmin) ?? panic("You are not the admin")
        signer.save(<- self.admin.createNewMinter(allowedAmount: 1000.0), to: /storage/flowTokenMinter)
    }

    execute {
        log("flow minter created successfully")
    }
}