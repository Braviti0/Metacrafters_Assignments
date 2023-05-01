pub contract Pupils {

    pub resource interface name {
        pub let name: String
    }

    pub resource Pupil :name {
        pub let name: String
        pub var age: UInt
        init(_name: String, _age : UInt) {
            self.name = _name
            self.age = _age
    }
    }

    pub fun createPupil(name: String, age: UInt) : @Pupil {
        return <- create Pupil(_name: name, _age: age)
    }

}
