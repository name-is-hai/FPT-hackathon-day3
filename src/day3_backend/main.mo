import Debug "mo:base/Debug";
import ExperimentalCycles "mo:base/ExperimentalCycles";
import HashMap "mo:base/HashMap";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Prim "mo:prim";
import Principal"mo:base/Principal";
import Result "mo:base/Result";

import Animals "animal";
import Person "custom";

actor {
 
//Challenge 1
  public type Person = Person.Person;
  let tmp : Person = {
    id = "HE160490";
    name = "Vu Dao Ngoc Hai";
    age = 22;
  };

  public func getInfor () : async Person {
    return tmp;
  };

  //Challenge 2
  public type Animal = Animals.Animals;
  let cat : Animal = {
    species = "Cat";
    energy = 100;
    place = "Wild";
    weight = 18;
  };

  public func getAnimal() : async Text {
    return cat.species;
  };

  //Challenge 4
  public func create_animal_then_takes_a_break (species : Text, energy: Nat) : async Animal {
    var newAnimal : Animal = {
      species = species;
      energy = energy;
      weight = 100;
      place = "Cat house";
    };

    newAnimal := Animals.animal_sleep(newAnimal);
    return newAnimal;
  };

  // Challenge 5
  public type List<Animal> = ?(Animal, List<Animal>); 
  var listAnimal = List.nil<Animal>();

  // Challenge 6
  public func push_animal(animal : Animal): async () {
     listAnimal := List.push(animal, listAnimal);
  };
  public func get_animals() : async List.List<Animal> {
    return listAnimal;
  };

  // Challenge 11:
  public shared({caller}) func is_anonymous(): async Bool {
    Principal.isAnonymous(caller);
  };

  public shared(msg) func whoami1() : async Principal {
    let principal_caller = msg.caller;
    return(principal_caller);
  };

 public shared({caller}) func whoami2() : async Principal {
    return(caller);
  };

  // Challenge 12
  let favoriteNumber = HashMap.HashMap<Principal, Nat>(0, Principal.equal, Principal.hash);

  // Challenge 13

  // public shared({caller}) func add_favorite_number(n: Nat): async() {
  //   favoriteNumber.put(caller, n);
  // };

  public shared({caller}) func show_favorite_number (): async ?Nat {
    return favoriteNumber.get(caller);
  };

  // Challenge 14
  public shared({caller}) func add_favorite_number(n: Nat): async Result.Result<Text,Text> {
    var value = favoriteNumber.get(caller);
    switch(value) {
      case(null) {
        favoriteNumber.put(caller,n);
        return #ok("You've successfully registered your number");
      };

      case(?something) {
        return #err("You've already registered your number")
      };

    }
  };


  // Challenge 15
  public shared({caller}) func update_favorite_number(n: Nat) : async Result.Result<Text,Text> {
    var value = favoriteNumber.get(caller);
    switch(value) {
      case (null) {
        return #err ("You haven't registered your favorite number yet!");
      };
      case(_) {
        favoriteNumber.put(caller,n);
        return #ok ("Updated successfully!");
      };
    };
  };

  public shared({caller}) func delete_favorite_number(n: Nat) :async Result.Result<Text,Text> {
    let valueCaller = favoriteNumber.get(caller);
    switch(valueCaller) {
      case(null) {
        return #err("You haven't registered your favorite number yet!");
      };
      case(?something) {
        if(n == something) {
          favoriteNumber.delete(caller);
          return #ok("You have removed " #Nat.toText(n) #" out of favorite numbers");
        }else {
          return #err("Some thing went wrong here!");
        };
      };
  };
};

  // Challenge 16
  public func deposit_cycles () : async Nat {
    let depositAmount = 100000;
    ExperimentalCycles.add(depositAmount);
    return depositAmount;
  };
  
  // Challenge 17
  let other_canister : actor {deposit_cycles : () -> async Nat} = actor("CANISTER_ID"); //from deposit_cycles canister
  private func withdraw_cycles(n: Nat) : async Nat {
    Cycle.add(n);
    await other_canister.deposit_cycles(); 
  };

  // Challenge 18
  stable var count = 0;
  stable var versionNumber = 0;
  public func  increment_counter (n: Nat): async Nat {
    count += n;
    versionNumber +=1;
    Debug.print(debug_show(versionNumber));
    return count;
  };

  // Challenge 19.
  stable var entries : [(Principal, Nat)] = [];
  stable var hashMapSize: Nat = entries.size();

  system func preUpgrade() {
      entries := Iter.toArray(hashMap.entries());
  };

  system func postUpgrade() {
    versionNumber := versionNumber + 1;
    hashMap:= HashMap.fromIter<Principal, Nat>(entries.vals(), hashMapSize, Principal.equal, Principal.hash );
  };
};