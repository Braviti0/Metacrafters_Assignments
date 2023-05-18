pub contract House {

    pub resource interface HomePub {
        pub var GateClosed: Bool
        pub var MainDoorClosed: Bool
        pub var OutdoorLights: Bool
        pub var IndoorLights: Bool    
    }

    pub resource Home : HomePub {
        pub var GateClosed: Bool
        pub var MainDoorClosed: Bool
        pub var OutdoorLights: Bool
        pub var IndoorLights: Bool

        init () {
            self.GateClosed = true
            self.MainDoorClosed = false
            self.OutdoorLights = true
            self.IndoorLights = true
        }

        pub fun OpenGate() {
            self.GateClosed = false
        }

        pub fun CloseGate() {
            self.GateClosed == true
        }

        pub fun OpenMainDoor() {
            self.MainDoorClosed = false
        }

        pub fun CloseMainDoor() {
            self.MainDoorClosed == true
        }

        pub fun OutdoorLightsOff() {
            self.OutdoorLights = false
        }

        pub fun OutdoorLightsOn() {
            self.OutdoorLights == true
        }

        pub fun IndoorLightsOff() {
            self.IndoorLights = false
        }

        pub fun IndoorLightsOn() {
            self.IndoorLights == true
        }

    }

    pub resource interface Permit {
        pub fun depositPermit(Proxy:Capability<&Home>)
    }

    pub resource Family: Permit {
        pub var Proxy : Capability<&Home>?

        pub fun depositPermit(Proxy:Capability<&Home>) {
            self.Proxy = Proxy
        }

        init () {
            self.Proxy = nil
        }

    }

    pub fun createFamily(): @Family {
        return <- create Family()
    }

    pub fun createHome (): @Home {
        return <- create Home()
    }

}
 