import std/unittest
import pkg/lazyseq

suite "lazy sequences":

  test "turns a normal seq into a lazy sequence":
    let lazyseq = @[1, 2, 3].lazy
    check lazyseq() == 1
    check lazyseq() == 2
    check lazyseq() == 3

  test "evaluates a normal seq in reverse":
    let reverse = @[1, 2, 3].reverse
    check reverse() == 3
    check reverse() == 2
    check reverse() == 1

  test "evaluates a lazy sequence into a normal seq":
    check @[1, 2, 3].reverse.toSeq == @[3, 2, 1]

  test "generates infinite repetition":
    let repetition = 42.repeat()
    check repetition() == 42
    check repetition() == 42
    check repetition() == 42
    check repetition() == 42

  test "truncates a lazy sequence":
    check 42.repeat().take(2).toSeq == @[42, 42]

  test "concatenates lazy sequences":
    check (@[1, 2].lazy & @[3, 4].lazy).toSeq == @[1, 2, 3, 4]

  test "zips two lazy sequences":
    check zip(@[1, 2].lazy, @["a", "b"].lazy).toSeq == @[(1, "a"), (2, "b")]

  test "maps a lazy sequence into another":
    check @[1, 2, 3].lazy.map(x => $x).toSeq == @["1", "2", "3"]

  test "reduces a lazy sequence":
    check @[1, 2, 3, 4].lazy.reduce(0, (x, y) => x + y) == 10
    check @[1, 2, 3, 4].lazy.reduce(1, (x, y) => x * y) == 24
    check @[1, 2, 3, 4].lazy.reduce("", (x, y) => x & $y) == "1234"

  test "filters a lazy sequence":
    let naturals = generate[int]:
      var n = 0
      while true:
        yield n
        inc n

    check naturals.filter(x => (x mod 2 == 0)).take(3).toSeq == @[0, 2, 4]
