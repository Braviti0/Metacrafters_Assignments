// Import the carRegistry contract from the blockchain.
import carRegistry from 0x01

// Define a public script named `getCar` that returns a Car struct.
pub fun getCar(index: UInt): carRegistry.Car {

    // Return the Car struct at the specified index in the carRegister dictionary.
    return carRegistry.carRegister[index]
}
