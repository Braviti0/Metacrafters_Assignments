// Import the carRegistry contract from the blockchain.
import carRegistry from "./carRegistry"

// Define a script named that returns a Car struct.
pub fun main(index: UInt): carRegistry.Car {
    // Return the Car struct at the specified index in the carRegister dictionary.
    return carRegistry.carRegister[index]
}
 