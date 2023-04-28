pub contract Test {

    pub var dictionaryOfGreetings: @{String: Greeting}

    pub resource Greeting {
        pub let message: String
        init() {
            self.message = "Hello, Mars!"
        }
    }

    pub fun addGreeting(greeting: @Greeting) {
        let key = greeting.message
        
        let oldGreeting <- self.dictionaryOfGreetings[key] <- greeting
        destroy oldGreeting
    }

    pub fun removeGreeting(key: String): @Greeting {
        let greeting <- self.dictionaryOfGreetings.remove(key: key) ?? panic("Could not find the greeting!")
        return <- greeting
    }

    pub fun accessGreeting(key: String): &Greeting {
        return (&self.dictionaryOfGreetings[key] as &Greeting?) ?? panic("could not get the greeting")
    }


    init() {
        self.dictionaryOfGreetings <- {}
    }

}
