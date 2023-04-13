// Import the carRegistry contract from the blockchain.
import carRegistry from 0x01

// Define a public function named `main` that returns a Car struct.
pub fun main(index: UInt): carRegistry.Car {

    // Return the Car struct at the specified index in the carRegister dictionary.
    return carRegistry.carRegister[index]
}
