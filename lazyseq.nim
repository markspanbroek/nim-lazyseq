import std/sugar

export `=>`, `->`

type LazySeq*[T] = iterator(): T

template generate*[T](body): LazySeq[T] =
  iterator generator(): T {.closure.} =
    body
  generator

proc lazy*[T](sequence: seq[T]): LazySeq[T] =
  generate[T]:
    for x in sequence:
      yield x

proc reverse*[T](sequence: seq[T]): LazySeq[T] =
  generate[T]:
    for i in 1..sequence.len:
      yield sequence[^i]

proc toSeq*[T](lazyseq: LazySeq[T]): seq[T] =
  for x in lazyseq():
    result.add(x)

proc repeat*[T](value: T): LazySeq[T] =
  generate[T]:
    while true:
      yield value

proc take*[T](lazyseq: LazySeq[T], amount: int): LazySeq[T] =
  generate[T]:
    for i in 0..<amount:
      yield lazyseq()

proc `&`*[T](a, b: LazySeq[T]): LazySeq[T] =
  generate[T]:
    for x in a(): yield x
    for x in b(): yield x

proc zip*[T,U](a: LazySeq[T], b: LazySeq[U]): LazySeq[(T,U)] =
  generate[(T,U)]:
    var done = false
    while not done:
      let x = a()
      let y = b()
      done = a.finished or b.finished
      if not done:
        yield (x, y)

proc map*[T, U](lazyseq: LazySeq[T], transform: T -> U): LazySeq[U] =
  generate[U]:
    for x in lazyseq():
      yield transform(x)

proc filter*[T](lazySeq: LazySeq[T], check: T -> bool): LazySeq[T] =
  generate[T]:
    for x in lazyseq():
      if check(x):
        yield x

proc reduce*[T, U](lazyseq: LazySeq[T], initial: U, operation: (U, T) -> U): U =
  result = initial
  for x in lazyseq():
    result = operation(result, x)
