pub contract Class {

    pub resource Pupil {
        pub let name: String
        init(_name: String) {
            self.name = _name
    }
    }

    pub var Pupils: @[Pupil]

    pub fun createPupil(name: String) {
        self.Pupils.append(<- create Pupil(_name: name))
    }

    init () {
        self.Pupils <- []
    }

    pub fun removePupil(index: UInt):@Pupil {
        return <-self.Pupils.remove(at: index)
    }

}
