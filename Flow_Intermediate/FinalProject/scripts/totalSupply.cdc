import redTibbyToken from "../contracts/rTT.cdc"

pub fun main (): UFix64 {
    log("rTT total supply is: ".concat(redTibbyToken.totalSupply.toString()))
    return redTibbyToken.totalSupply
}