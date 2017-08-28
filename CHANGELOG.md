## 0.1.19: Bug fixes

Added tie-breaking exponentiation operator implementations for concrete integer types in the standard library.

## 0.1.18: Exponentiation operators

* Added the exponentiation operator `**` and the compound assignment operator `**=`.
* Deprecated `BinaryInteger.pow(_:_:)` and `Math.pow(_:_:)`.

## 0.1.17: CocoaPods

Added a PodSpec file (and a `.swift-version` file) for CocoaPods support.

## 0.1.16: Bug fixes

Worked around a compiler segmentation fault by assuming memory bound instead of binding memory.

## 0.1.15: Bug fixes and documentation improvements

* Updated doc comments.
* Updated generic algorithms for revised integer protocols.

## 0.1.14: Bug fixes

* Removed `Complex.isCanonical` and `Complex.polar`.
* Fixed implementation of `Complex.isNaN` and `Complex.isSignalingNaN` to align with C/C++ standards: a complex value is NaN if at least one of its components is NaN *and* the other is not infinite.
* Fixed implementation of `Complex` multiplication and division to align handling of special values with C/C++ standards.
* Fixed implementation of `Complex.tanh(_:)` to align handling of special values with C/C++ standards.
* Refined implementation of `Complex.description` for values with a negative imaginary component.
* Fixed implementation of `Rational` initializers that convert from a `BinaryFloatingPoint` value.

## 0.1.13: Bug fixes

Fixed implementation of `Rational.isProper`.

## 0.1.12: Integer square root and cube root

* Added integer square root and cube root functions.
* Removed `power(of:)` requirement from `Math`, substituting `pow(_:_:)` (formerly an extension method).

## 0.1.11: Bug fixes

* Expanded tests.
* Fixed implementation of certain default implementations for protocol requirements of `Math` and `Real`.

## 0.1.10: Codable

Conformed `Complex` and `Rational` to `Codable`.

## 0.1.9: Bug fixes

* Renamed `FloatingPointMath` to `Real`.
* Updated implementation of `Complex.hyperbolicTangent` to align handling of special values to revised C standard.
* Updated `swift-tools-version` to `4.0`.

## 0.1.8: Bug fixes and documentation improvements

* Removed initializer requirements from `FloatingPointMath`, moving functionality to an extension to `BinaryFloatingPoint`.
* Reorganized code and edited comments to improve documentation.

## 0.1.7: Random numbers

* Added initial implementation of a pseudo-random number generator protocol and conforming types.
* Restored constraints on `FloatingPointMath` to refine `FloatingPoint` and not `BinaryFloatingPoint`.

## 0.1.6: Bug fixes

Modified `FloatingPointMath` to refine `BinaryFloatingPoint` instead of `FloatingPoint`.

## 0.1.5: Bug fixes

Fixed implementation of comparison in `Rational<T>`.

## 0.1.4: Bug fixes

Fixed several implementations in `Rational<T>` and added tests.

## 0.1.3: Rational conversions

Added initializers to convert from floating-point or integer values to `Rational<T>`, and vice versa.

## 0.1.2: Initial pre-release

Initial implementation of:

* `Math`
* `FloatingPointMath`
* `Complex`
* `Rational`

...and extensions to:

* `UnsignedInteger`
* `Float`
* `Double`
