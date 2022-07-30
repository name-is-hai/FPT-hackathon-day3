module {

    // Challenge 7

    public type List<T> = ?(T,List<T>);

    public func is_null<T>(l : List<T>): async Bool {
        switch(l) {
            case(null) {
                return true;
            };
            case(_) {
                return false;
            };
        }
    };

    // Challenge 8;
    
    public func last<T>(l: List<T>): async ?T {
        switch(l) {
            case(null) {
                return null;
            };
            case(?(element,null)) return element;
            
            case(?(element,next_list)) return (last<T>(next_list));
        };

    };

  // Challenge 9

    public func size(list: List<T>): async Nat {
        func _size<T>(list : List<T>, n: Nat): Nat {
            switch(list) {
                case(null) return n;
                case(?(_, next_list)) {
                    return (_size<T>(next_list,n + 1));
                };
            }
        }; 
        return _size(list,0);
        
    };



  // Challenge 10

    public func get<T>(l : List<T>, n : Nat) : ?T {
    switch (n, l) {
      case (_, null) { null };
      case (0, (?(h, t))) { ?h };
      case (_, (?(_, t))) { get<T>(t, n - 1) };
    }
  };
  

}