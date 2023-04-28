import helloWorld from "./M4C3.cdc"

pub fun main(key: String): String {
  let ref = helloWorld.accessGreeting(key: key)
  return ref.message 
}
