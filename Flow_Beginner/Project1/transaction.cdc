// Import the carRegistry contract from the blockchain.
import carRegistry from 0x01

// Define a transaction that adds a new car to the registry.
transaction(_model: String, _brand: String, _owner: Address) {

    // The prepare function sets the signer of the transaction to the AuthAccount.
    prepare(signer: AuthAccount) {
        // In this case, the prepare function doesn't need to do anything else.
    }

    // The execute function calls the addCar function of the carRegistry contract with the provided parameters.
    execute {
        carRegistry.addCar(model: _model, brand: _brand, owner: _owner)

        // Log a message to indicate that the car details have been stored.
        log("Car details stored.")

        // Log the index of the new car in the carRegister dictionary.
        log("Your index is")
        log(carRegistry.carRegister.length - 1)
    }
}
