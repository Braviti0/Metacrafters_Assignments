pub contract Pupils {

    pub resource Pupil {
        pub let name: String
        init(_name: String) {
            self.name = _name
    }
    }

    pub fun createPupil(name: String) : @Pupil {
        return <- create Pupil(_name: name)
    }

}
