import Pupils from "./M5C1c.cdc"

transaction(_name: String) {

  prepare(signer: AuthAccount) {
    // create the resource
    var Pupil <- Pupils.createPupil(name: _name)

    // save the resource
    signer.save(<- Pupil, to: /storage/Classroom)

    //borrow the resource from /storage/Classroom
    var pupilReloaded = signer.borrow<&Pupils.Pupil>(from: /storage/Classroom) ?? panic("There is no student in the classroom")

    // Return the name field of the resource
    log(pupilReloaded.name)

  }
}
