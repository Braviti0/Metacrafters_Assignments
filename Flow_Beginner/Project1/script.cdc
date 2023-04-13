import carRegistry from 0x01

pub fun main(index: UInt): carRegistry.Car {
    return carRegistry.carRegister[index]
}
