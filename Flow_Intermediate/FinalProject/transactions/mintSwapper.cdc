import FungibleToken from "../contracts/FTstandard.cdc"
import redTibbyToken from "../contracts/rTT.cdc"
import FlowToken from "../contracts/FlowToken.cdc"
import SwapperContract from "../contracts/Swapper.cdc"


transaction () {
    prepare (signer: AuthAccount) {
        signer.save(<- SwapperContract.mintSwapper(), to: /storage/rttSwapper)
        log("swapper minted")
    }
}