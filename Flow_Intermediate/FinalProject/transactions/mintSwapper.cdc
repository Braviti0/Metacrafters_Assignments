import SwapperContract from "../contracts/Swapper.cdc"


transaction () {
    prepare (signer: AuthAccount) {
        signer.save(<- SwapperContract.mintSwapper(), to: /storage/rttSwapper)
        log("swapper minted")
    }
}