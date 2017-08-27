# NumericAnnex

[![Build Status](https://travis-ci.org/xwu/NumericAnnex.svg?branch=master)](https://travis-ci.org/xwu/NumericAnnex)
[![codecov](https://codecov.io/gh/xwu/NumericAnnex/branch/master/graph/badge.svg)](https://codecov.io/gh/xwu/NumericAnnex)

NumericAnnex supplements the numeric facilities provided in the Swift standard
library.


## Features

- The exponentiation operator `**` and the compound assignment operator `**=`.
- Extension methods for `BinaryInteger` exponentiation, square root, cube root,
  greatest common divisor, and least common multiple.
- `Math`, a protocol for signed numeric types that support elementary functions.
- `Real`, a protocol for floating-point types that support elementary functions
  and a selection of special functions.
- `PRNG`, a protocol for pseudo-random number generators.
- `Rational`, a value type to represent rational values which supports division
  by zero.
- `Complex`, a value type to represent complex values in Cartesian form.
- `Random` and `Random.Xoroshiro`, two reference types implementing efficient
  pseudo-random number generators.

> Note: This project is in the early stages of development and is not
> production-ready at this time.


## Requirements

NumericAnnex now requires Xcode 9 beta 5 or later, or a recent development
snapshot of Swift 4.0 that includes the revised numeric protocols.

On Apple platforms, it requires the Security framework for cryptographically
secure random bytes.


## Installation

After NumericAnnex has been cloned or downloaded locally, build the library
using the command `swift build` (macOS) or `swift build -Xcc -D_GNU_SOURCE`
(Linux). Run tests with the command `swift test` (macOS) or
`swift test -Xcc -D_GNU_SOURCE` (Linux). An Xcode project can be generated with
the command `swift package generate-xcodeproj`.

To add the package as a dependency using [CocoaPods](https://cocoapods.org),
insert the following line in your `Podfile`:

```ruby
pod 'NumericAnnex', '~> 0.1.18'
```

[Swift Package Manager](https://swift.org/package-manager/) can also be used to
add the package as a dependency. See Swift documentation for details.


## Basic Usage

```swift
import NumericAnnex

var x: Ratio = 1 / 4
// Ratio is a type alias for Rational<Int>.

print(x.reciprocal())
// Prints "4".

x *= 8
print(x + x)
// Prints "4".

x = Ratio(Float.phi) // Golden ratio.
print(x)
// Prints "13573053/8388608".

var z: Complex64 = 42 * .i
// Complex64 is a type alias for Complex<Float>.

print(Complex.sqrt(z))
// Prints "4.58258 + 4.58258i".

z = .pi + .i * .log(2 - .sqrt(3))
print(Complex.cos(z).real)
// Prints "-2.0".
```


## Documentation

All public protocols, types, and functions have been carefully documented in the
code. See the [formatted reference](https://xwu.github.io/NumericAnnex/) for
details.

The project adheres to many design patterns found in the Swift standard library.
For example, `Math` types provide methods such as `cubeRoot()` and `tangent()`
just as `FloatingPoint` types provide methods such as `squareRoot()`.

No free functions are declared in this library unless they overload existing
ones in the Swift standard library. Instead, functions such as `cbrt(_:)` and
`tan(_:)` are provided as static members. This avoids collisions with C standard
library functions that you may wish to use. It also promotes clarity at the call
site when the result of a complex operation differs from that of its real
counterpart (e.g., `Complex128.cbrt(-8) != -2`).


## Future Directions

- Add more tests, including performance tests
- Design and implement additional methods on `PRNG`


## License

All original work is released under the MIT license. See
[LICENSE](https://github.com/xwu/NumericAnnex/blob/master/LICENSE) for details.

Portions of the complex square root and elementary transcendental functions use
checks for special values adapted from libc++. Code in libc++ is dual-licensed
under the MIT and UIUC/NCSA licenses.
