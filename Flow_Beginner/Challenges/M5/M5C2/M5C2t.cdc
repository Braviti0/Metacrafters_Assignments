import Pupils from "./M5C2c.cdc"

transaction(_name: String, _age: UInt) {

  prepare(signer: AuthAccount) {
    // create the resource
    var Pupil <- Pupils.createPupil(name: _name, age: _age)

    // save the resource
    signer.save(<- Pupil, to: /storage/Classroom)

    //link the restricted resource from /storage/Classroom
    var pupilReloaded = signer.link<&Pupils.Pupil{Pupils.name}>(/public/Classroom, target: /storage/Classroom) ?? panic("There is no student in the classroom")
  }
}
