import helloWorld from "./M4C4.cdc"

pub fun main(key: String): String {
  let ref = helloWorld.accessLanguage(key: key)
  return ref.message 
}

pub fun main2(key: String): String {
  let ref = helloWorld.accessLanguage(key: key)
  return ref.language
}
