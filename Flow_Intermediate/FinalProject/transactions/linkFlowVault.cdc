import FlowToken from "../contracts/FlowToken.cdc"
import FungibleToken from "../contracts/FTstandard.cdc"

transaction () {

    prepare (signer: AuthAccount) {
            signer.unlink(/public/flowToken)
            signer.link<&FlowToken.Vault{FungibleToken.Receiver, FungibleToken.Balance}>(
            /public/flowToken,
            target: /storage/flowToken
            )
    }

    execute {
        log("link Flow successfully")
    }
}