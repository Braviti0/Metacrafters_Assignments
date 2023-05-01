 pub contract Record {

    pub var name: String
    pub var distance: UInt

    pub event newRecord(_name: String, _distance: UInt)

    pub fun changeRecord(newName: String, newDistance: UInt) {

        pre {
            self.distance < newDistance : "The new recordholder must have run a longer distance"
        }
        self.name = newName
        self.distance = newDistance

        emit newRecord(_name: newName, _distance: newDistance)
    }

    init() {
        self.name = "None"
        self.distance = 0
    }
}