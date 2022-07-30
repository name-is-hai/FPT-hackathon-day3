module {

    // Challenge 2

    public type Animals = {
        species: Text;
        energy: Nat;
        weight: Nat;
        place: Text;
    };

    // Challenge 3
    public  func animal_sleep(animal : Animals) : Animals {

         let newAnimal : Animals =  {
            species = animal.species;
            energy = animal.energy + 10;
            weight = animal.weight;
            place = animal.place;
        };

        return newAnimal;
    }
}