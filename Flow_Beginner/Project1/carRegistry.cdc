pub contract carRegistry {

    // Dictionary that stores the list of cars owned by an address.
    pub var carRegister: [Car]
    
    // Struct that represents a car with its attributes.
    pub struct Car {
        pub let model: String
        pub let brand: String
        pub let owner: Address

        // Initializer function that sets the car's properties.
        init(_model: String, _brand: String, _owner: Address) {
            self.model = _model
            self.brand = _brand
            self.owner = _owner
        }
    }

    // Public function to add a new car to the registry.
    pub fun addCar(model: String, brand: String, owner: Address) {
        // Create a new Car instance with the provided data.
        let newCar = Car(_model: model, _brand: brand, _owner: owner)
        // Add the new car to the carRegister dictionary with the owner's address as the key.
        self.carRegister.append(newCar)
    }

    // Initializer function that initializes the carRegister dictionary to an empty dictionary.
    init() {
        self.carRegister = []
    }

}