Lazy Sequences
==============

Lazy evaluated sequences, that can be infinitely long.
Includes operations such as `map`, `filter`, `reduce` and `zip`.

Installation
------------

Use the [Nimble][1] package manager to add `lazy` to an existing project.
Add the following to its .nimble file:

```nim
requires "lazy >= 0.1.0 & < 0.2.0"
```

Examples
--------

Turn a normal sequence into a lazy sequence.
```nim
@[1, 2, 3].lazy
```

Lazy evaluate the reverse of a normal seq.
```nim
@[1, 2, 3].reverse  # equals @[3, 2, 1].lazy
```

Evaluate a lazy sequence into a normal seq (don't do this with infinite
sequences).
```nim
@[1, 2, 3].reverse.toSeq
```

An infinitely repeated value.
```nim
42.repeat()
```

Take the first n elements of a lazy sequence:
```nim
42.repeat().take(5)  # equals @[42, 42, 42, 42, 42].lazy
```

Concatenate two lazy sequences:
```nim
@[1, 2].lazy & @[3, 4].lazy  # equals @[1, 2, 3, 4].lazy
```

Combine (zip) two lazy sequences:
```nim
zip(@[1, 2].lazy, @["a", "b"].lazy)  # equals @[(1, "a"), (2, "b")].lazy
```

Transform (map) a lazy sequence into another:
```nim
@[1, 2, 3].lazy.map(x => $x)  # equals @["1", "2", "3"].lazy
```

Filter a lazy sequence:
```nim
@[1, 2, 3, 4].lazy.filter(x => (x mod 2 == 0))  # equals @[2, 4].lazy
```

Combine (reduce) all elements of a sequence:
```nim
@[1, 2, 3, 4].lazy.reduce(0, (x, y) => x + y)  # equals 10
@[1, 2, 3, 4].lazy.reduce(1, (x, y) => x * y)  # equals 24
@[1, 2, 3, 4].lazy.reduce("", (x, y) => x & $y)  # equals "1234"
```

Generate an infinite sequence:
```nim
let naturals = generate[int]:
  var n = 0
  while true:
    yield n
    inc n
```

[1]: https://github.com/nim-lang/nimble
