import carRegistry from 0x01

transaction(_model: String, _brand: String, _owner: Address) {

    prepare(signer: AuthAccount) {}

    execute {
        carRegistry.addCar(model: _model, brand: _brand, owner: _owner)
        log("Car details stored.")
        log("Your index is")
        log(carRegistry.carRegister.length - 1)
    }
}
