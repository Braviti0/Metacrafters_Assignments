import Pupils from "M5C2c.cdc"

pub fun main(address: Address) {
    // get the capability
  let publicCapability: Capability<&Pupils.Pupil{Pupils.name}> =
    getAccount(address).getCapability<&Pupils.Pupil{Pupils.name}>(/public/Classroom)

    // get the resource
  let testResource: &Pupils.Pupil{Pupils.name} = publicCapability.borrow() ?? panic("The capability doesn't exist or you did not specify the right type when you got the capability.")

  // log the accessible field
  log(testResource.name)

  // try to log the restricted field
  log(testResource.age)
}
