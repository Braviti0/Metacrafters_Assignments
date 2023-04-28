pub contract helloWorld {

    pub var dictionaryOfGreetings: @{String: Greeting}

    pub resource interface Language {
        pub let language:String
    }

    pub resource Greeting: Language {
        pub let message: String
         pub let language:String
        init() {
            self.message = "Hello, Mars!"
            self.language = "English"
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

    pub fun accessLanguage(key: String): &Greeting{Language} {
        return (&self.dictionaryOfGreetings[key] as &Greeting{Language}?) ?? panic("could not get the greeting")
    } 


    init() {
        self.dictionaryOfGreetings <- {}
    }

}
