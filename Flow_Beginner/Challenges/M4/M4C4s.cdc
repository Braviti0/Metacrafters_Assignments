import helloWorld from "./M4C4.cdc"

pub fun main(key: String) {
  let ref = helloWorld.accessLanguage(key: key)
  log(ref.message)
}

pub fun main2(key: String) {
  let ref = helloWorld.accessLanguage(key: key)
  log(ref.language)
}
