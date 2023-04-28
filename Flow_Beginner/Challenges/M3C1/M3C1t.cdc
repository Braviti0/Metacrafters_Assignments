import HelloWorld from "./M3C1.cdc"

transaction(_newNumber: Int) {

  prepare(signer: AuthAccount) {}

  execute {
    HelloWorld.updateMyNumber(newNumber: _newNumber)
  }
}
