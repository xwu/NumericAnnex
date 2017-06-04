//
//  Complex.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 3/25/17.
//
//  Note
//  ====
//
//  For maximum consistency with corresponding functions in C/C++, checks for
//  special values in `naturalExponential()`, `squareRoot()`, trigonometric
//  functions, and hyperbolic functions are adapted from libc++.
//
//  Code in libc++ is dual-licensed under the MIT and UIUC/NCSA licenses.
//  Copyright © 2009-2017 contributors to the LLVM/libc++ project.

/// A type to represent a complex value in Cartesian form.
///
/// Create new instances of `Complex<T>` using integer or floating-point
/// literals and the imaginary unit `Complex<T>.i`. For example:
///
/// ```swift
/// let x = 2 + 4 * .i // `x` is of type `Complex<Double>`
/// let y = 3.5 + 7 * .i // `y` is of type `Complex<Double>`
///
/// let z: Complex64 = .e + .pi * .i // `z` is of type `Complex<Float>`
/// ```
///
/// Additional Considerations
/// -------------------------
///
/// Floating-point types have special values that represent infinity or NaN
/// ("not a number"). Complex functions in different languages may return
/// different results when working with special values.
///
/// Many complex functions have [branch cuts][dfn], which are curves in the
/// complex plane across which a function is discontinuous. Different languages
/// may adopt different branch cut structures for the same complex function.
///
/// Implementations in `Complex<T>` adhere to the [C standard][std] (Annex G) as
/// closely as possible with respect to special values and branch cuts.
///
/// To users unfamiliar with complex functions, the principal value returned by
/// some complex functions may be unexpected. For example,
/// `Double.cbrt(-8) == -2`, which is the __real root__, while
/// `Complex.cbrt(-8) == 2 * Complex.exp(.i * .pi / 3)`, which is the
/// __principal root__.
///
/// [dfn]: http://mathworld.wolfram.com/BranchCut.html
/// [std]: http://www.open-std.org/JTC1/SC22/WG14/www/standards.html#9899
@_fixed_layout
public struct Complex<T : FloatingPointMath>
where T : _ExpressibleByBuiltinFloatLiteral {
  // ---------------------------------------------------------------------------
  // MARK: Stored Properties
  // ---------------------------------------------------------------------------

  /// The real component of the complex value.
  public var real: T

  /// The imaginary component of the complex value.
  public var imaginary: T

  // ---------------------------------------------------------------------------
  // MARK: Initializers
  // ---------------------------------------------------------------------------

  /// Creates a new value from the given real and imaginary components.
  ///
  /// - Parameters:
  ///   - real: The new value's real component.
  ///   - imaginary: The new value's imaginary component.
  @_transparent // @_inlineable
  public init(real: T = 0, imaginary: T = 0) {
    self.real = real
    self.imaginary = imaginary
  }

  /// Creates a new value from the given polar coordinates `(r, theta)`.
  ///
  /// - Parameters:
  ///   - r: The new value's radial coordinate.
  ///   - theta: The new value's angular coordinate.
  @_transparent // @_inlineable
  public init(r: T, theta: T) {
    self.real = r * T.cos(theta)
    self.imaginary = r * T.sin(theta)
  }

  /// Creates a new value from the given real component, rounded to the closest
  /// possible representation.
  ///
  /// If two representable values are equally close, the result is the value
  /// with more trailing zeros in its significand bit pattern.
  ///
  /// - Parameters:
  ///   - real: The integer to convert to a floating-point real component.
  @_transparent // @_inlineable
  init(_ real: Int) {
    self.real = T(real)
    self.imaginary = 0
  }

  /// Creates a new value from the given real component, rounded to the closest
  /// possible representation.
  ///
  /// If two representable values are equally close, the result is the value
  /// with more trailing zeros in its significand bit pattern.
  ///
  /// - Parameters:
  ///   - real: The integer to convert to a floating-point real component.
  @_transparent // @_inlineable
  init(_ real: Int8) {
    self.real = T(real)
    self.imaginary = 0
  }

  /// Creates a new value from the given real component, rounded to the closest
  /// possible representation.
  ///
  /// If two representable values are equally close, the result is the value
  /// with more trailing zeros in its significand bit pattern.
  ///
  /// - Parameters:
  ///   - real: The integer to convert to a floating-point real component.
  @_transparent // @_inlineable
  init(_ real: Int16) {
    self.real = T(real)
    self.imaginary = 0
  }

  /// Creates a new value from the given real component, rounded to the closest
  /// possible representation.
  ///
  /// If two representable values are equally close, the result is the value
  /// with more trailing zeros in its significand bit pattern.
  ///
  /// - Parameters:
  ///   - real: The integer to convert to a floating-point real component.
  @_transparent // @_inlineable
  init(_ real: Int32) {
    self.real = T(real)
    self.imaginary = 0
  }

  /// Creates a new value from the given real component, rounded to the closest
  /// possible representation.
  ///
  /// If two representable values are equally close, the result is the value
  /// with more trailing zeros in its significand bit pattern.
  ///
  /// - Parameters:
  ///   - real: The integer to convert to a floating-point real component.
  @_transparent // @_inlineable
  init(_ real: Int64) {
    self.real = T(real)
    self.imaginary = 0
  }

  /// Creates a new value from the given real component, rounded to the closest
  /// possible representation.
  ///
  /// If two representable values are equally close, the result is the value
  /// with more trailing zeros in its significand bit pattern.
  ///
  /// - Parameters:
  ///   - real: The integer to convert to a floating-point real component.
  @_transparent // @_inlineable
  init(_ real: UInt) {
    self.real = T(real)
    self.imaginary = 0
  }

  /// Creates a new value from the given real component, rounded to the closest
  /// possible representation.
  ///
  /// If two representable values are equally close, the result is the value
  /// with more trailing zeros in its significand bit pattern.
  ///
  /// - Parameters:
  ///   - real: The integer to convert to a floating-point real component.
  @_transparent // @_inlineable
  init(_ real: UInt8) {
    self.real = T(real)
    self.imaginary = 0
  }

  /// Creates a new value from the given real component, rounded to the closest
  /// possible representation.
  ///
  /// If two representable values are equally close, the result is the value
  /// with more trailing zeros in its significand bit pattern.
  ///
  /// - Parameters:
  ///   - real: The integer to convert to a floating-point real component.
  @_transparent // @_inlineable
  init(_ real: UInt16) {
    self.real = T(real)
    self.imaginary = 0
  }

  /// Creates a new value from the given real component, rounded to the closest
  /// possible representation.
  ///
  /// If two representable values are equally close, the result is the value
  /// with more trailing zeros in its significand bit pattern.
  ///
  /// - Parameters:
  ///   - real: The integer to convert to a floating-point real component.
  @_transparent // @_inlineable
  init(_ real: UInt32) {
    self.real = T(real)
    self.imaginary = 0
  }

  /// Creates a new value from the given real component, rounded to the closest
  /// possible representation.
  ///
  /// If two representable values are equally close, the result is the value
  /// with more trailing zeros in its significand bit pattern.
  ///
  /// - Parameters:
  ///   - real: The integer to convert to a floating-point real component.
  @_transparent // @_inlineable
  init(_ real: UInt64) {
    self.real = T(real)
    self.imaginary = 0
  }

  // ---------------------------------------------------------------------------
  // FIXME: If corresponding requirements are added to FloatingPoint
  // add init<U : Integer>(_: U) as well as init?<U : Integer>(exactly: U).
  // ---------------------------------------------------------------------------
}

extension Complex where T : BinaryFloatingPoint {
  // ---------------------------------------------------------------------------
  // MARK: Initializers (Constrained)
  // ---------------------------------------------------------------------------

  /// Creates a new value from the given real component, rounded to the closest
  /// possible representation.
  ///
  /// - Note: This initializer creates only instances of
  ///   `Complex<T> where T : BinaryFloatingPoint`.
  ///
  /// - Parameters:
  ///   - real: The value to convert to a real component of type `T`.
  @_transparent // @_inlineable
  public init(_ real: Float) {
    self.real = T(real)
    self.imaginary = 0
  }

  /// Creates a new value from the given real component, rounded to the closest
  /// possible representation.
  ///
  /// - Note: This initializer creates only instances of
  ///   `Complex<T> where T : BinaryFloatingPoint`.
  ///
  /// - Parameters:
  ///   - real: The value to convert to a real component of type `T`.
  @_transparent // @_inlineable
  public init(_ real: Double) {
    self.real = T(real)
    self.imaginary = 0
  }

  // ---------------------------------------------------------------------------
  // FIXME: If corresponding requirements are added to BinaryFloatingPoint
  // add init<U : BinaryFloatingPoint>(_: U) as well as
  // init?<U : BinaryFloatingPoint>(exactly: U).
  // ---------------------------------------------------------------------------
}

extension Complex {
  // ---------------------------------------------------------------------------
  // MARK: Static Properties
  // ---------------------------------------------------------------------------

  /// The imaginary unit i.
  @_transparent // @_inlineable
  public static var i: Complex {
    return Complex(real: 0, imaginary: 1)
  }

  // ---------------------------------------------------------------------------
  // MARK: Computed Properties
  // ---------------------------------------------------------------------------

  /// The principal argument (phase angle) of this value.
  ///
  /// Special cases are handled as if calling `T.atan2(imaginary, real)`. The
  /// result lies in the range [-π, π].
  @_transparent // @_inlineable
  public var argument: T {
    return T.atan2(imaginary, real)
  }

  /// A Boolean value indicating whether the instance's real and imaginary
  /// components are both in canonical form, as defined in the [IEEE 754
  /// specification][spec]. Every `Float` or `Double` value is canonical.
  ///
  /// [spec]: http://ieeexplore.ieee.org/servlet/opac?punumber=4610933
  @_transparent // @_inlineable
  public var isCanonical: Bool {
    return real.isCanonical && imaginary.isCanonical
  }

  /// A Boolean value indicating whether the instance's real and imaginary
  /// components are both finite.
  ///
  /// All values other than NaN and infinity are considered finite.
  @_transparent // @_inlineable
  public var isFinite: Bool {
    return real.isFinite && imaginary.isFinite
  }

  /// A Boolean value indicating whether the instance's real and/or imaginary
  /// components are infinite.
  ///
  /// Note that `isFinite` and `isInfinite` do not form a dichotomy because NaN
  /// is neither finite nor infinite.
  @_transparent // @_inlineable
  public var isInfinite: Bool {
    return real.isInfinite || imaginary.isInfinite
  }

  /// A Boolean value indicating whether the instance's real and/or imaginary
  /// components are NaN ("not a number").
  ///
  /// Because NaN is not equal to any value, including NaN, use this property
  /// instead of the equal-to operator (`==`) or not-equal-to operator (`!=`) to
  /// test whether a value is or is not NaN.
  ///
  /// This property is `true` for both quiet and signaling NaNs.
  @_transparent // @_inlineable
  public var isNaN: Bool {
    return real.isNaN || imaginary.isNaN
  }

  /// A Boolean value indicating whether the instance's real and/or imaginary
  /// components are signaling NaNs.
  ///
  /// Signaling NaNs typically raise the Invalid flag when used in general
  /// computing operations.
  @_transparent // @_inlineable
  public var isSignalingNaN: Bool {
    return real.isSignalingNaN || imaginary.isSignalingNaN
  }

  /// A Boolean value indicating whether the instance is equal to zero.
  ///
  /// The `isZero` property of a value `z` is `true` when both real and
  /// imaginary components represent either `-0.0` or `+0.0`.
  @_transparent // @_inlineable
  public var isZero: Bool {
    return real.isZero && imaginary.isZero
  }

  /// The magnitude (modulus, absolute value) of this value.
  ///
  /// Special cases are handled as if calling `T.hypot(real, imaginary)`.
  @_transparent // @_inlineable
  public var magnitude: T {
    return T.hypot(real, imaginary)
  }

  /// The polar coordinates representing this value, equivalent to
  /// `(r: magnitude, theta: argument)`.
  @_transparent // @_inlineable
  public var polar: (r: T, theta: T) {
    return (r: magnitude, theta: argument)
  }

  /// The squared magnitude (field norm, absolute square) of this value.
  ///
  /// This is less costly to compute than `magnitude` and, in some cases, can be
  /// used in its place. For example, if `a.magnitude > b.magnitude`, then
  /// `a.squaredMagnitude > b.squaredMagnitude`.
  @_transparent // @_inlineable
  public var squaredMagnitude: T {
    if real.isInfinite { return abs(real) }
    if imaginary.isInfinite { return abs(imaginary) }
    return real * real + imaginary * imaginary
  }

  // ---------------------------------------------------------------------------
  // MARK: Methods
  // ---------------------------------------------------------------------------

  /// Returns the complex conjugate of this value, obtained by reversing the
  /// sign of the imaginary component.
  @_transparent // @_inlineable
  public func conjugate() -> Complex {
    return Complex(real: real, imaginary: -imaginary)
  }

  /// Returns the projection of this value onto the Riemann sphere.
  ///
  /// For most values `z`, `z.projection() == z`. The projection of any complex
  /// infinity is positive real infinity. The sign of the imaginary component is
  /// preserved in the sign of zero; that is,
  /// `z.projection().imaginary.sign == z.imaginary.sign`.
  @_transparent // @_inlineable
  public func projection() -> Complex {
    if real.isInfinite || imaginary.isInfinite {
      return Complex(
        real: .infinity, imaginary: T(signOf: imaginary, magnitudeOf: 0)
      )
    }
    return self
  }

  /// Returns the reciprocal (multiplicative inverse) of this value.
  @_transparent // @_inlineable
  public func reciprocal() -> Complex {
    let denominator = squaredMagnitude
    return Complex(
      real: real / denominator, imaginary: -imaginary / denominator
    )
  }
}

extension Complex : ExpressibleByFloatLiteral {
  // ---------------------------------------------------------------------------
  // MARK: ExpressibleByFloatLiteral
  // ---------------------------------------------------------------------------

  @_transparent // @_inlineable
  public init(floatLiteral value: T) {
    self.real = value
    self.imaginary = 0
  }
}

extension Complex : ExpressibleByIntegerLiteral {
  // ---------------------------------------------------------------------------
  // MARK: ExpressibleByIntegerLiteral
  // ---------------------------------------------------------------------------

  @_transparent // @_inlineable
  public init(integerLiteral value: Int) {
    self.real = T(value)
    self.imaginary = 0
  }
}

extension Complex : CustomStringConvertible {
  // ---------------------------------------------------------------------------
  // MARK: CustomStringConvertible
  // ---------------------------------------------------------------------------

  @_transparent // @_inlineable
  public var description: String {
    return "\(real) + \(imaginary)i"
  }
}

extension Complex : Equatable {
  // ---------------------------------------------------------------------------
  // MARK: Equatable
  // ---------------------------------------------------------------------------

  @_transparent // @_inlineable
  public static func == (lhs: Complex, rhs: Complex) -> Bool {
    return lhs.real == rhs.real && lhs.imaginary == rhs.imaginary
  }
}

extension Complex : Hashable {
  // ---------------------------------------------------------------------------
  // MARK: Hashable
  // ---------------------------------------------------------------------------

  // @_transparent // @_inlineable
  public var hashValue: Int {
    return _fnv1a(real, imaginary)
  }
}
extension Complex : Numeric {
  // ---------------------------------------------------------------------------
  // MARK: Numeric
  // ---------------------------------------------------------------------------

  @_transparent // @_inlineable
  public init?<U>(exactly source: U) where U : BinaryInteger {
    guard let t = T(exactly: source) else { return nil }
    self.real = t
    self.imaginary = 0
  }

  @_transparent // @_inlineable
  public static func + (lhs: Complex, rhs: Complex) -> Complex {
    return Complex(
      real: lhs.real + rhs.real, imaginary: lhs.imaginary + rhs.imaginary
    )
  }

  @_transparent // @_inlineable
  public static func += (lhs: inout Complex, rhs: Complex) {
    lhs.real += rhs.real
    lhs.imaginary += rhs.imaginary
  }

  @_transparent // @_inlineable
  public static func - (lhs: Complex, rhs: Complex) -> Complex {
    return Complex(
      real: lhs.real - rhs.real, imaginary: lhs.imaginary - rhs.imaginary
    )
  }

  @_transparent // @_inlineable
  public static func -= (lhs: inout Complex, rhs: Complex) {
    lhs.real -= rhs.real
    lhs.imaginary -= rhs.imaginary
  }

  @_transparent // @_inlineable
  public static func * (lhs: Complex, rhs: Complex) -> Complex {
    return Complex(
      real: lhs.real * rhs.real - lhs.imaginary * rhs.imaginary,
      imaginary: lhs.real * rhs.imaginary + lhs.imaginary * rhs.real
    )
  }

  @_transparent // @_inlineable
  public static func *= (lhs: inout Complex, rhs: Complex) {
    let t = lhs.real
    lhs.real = lhs.real * rhs.real - lhs.imaginary * rhs.imaginary
    lhs.imaginary = t * rhs.imaginary + lhs.imaginary * rhs.real
  }
}

extension Complex : SignedNumeric {
  // ---------------------------------------------------------------------------
  // MARK: SignedNumeric
  // ---------------------------------------------------------------------------

  @_transparent // @_inlineable
  public static prefix func - (operand: Complex) -> Complex {
    return Complex(real: -operand.real, imaginary: -operand.imaginary)
  }

  @_transparent // @_inlineable
  public mutating func negate() {
    real.negate()
    imaginary.negate()
  }
}

extension Complex : Math {
  // ---------------------------------------------------------------------------
  // MARK: Math
  // ---------------------------------------------------------------------------

  @_transparent // @_inlineable
  public static var pi: Complex {
    return Complex(real: .pi)
  }

  @_transparent // @_inlineable
  public static var e: Complex {
    return Complex(real: .e)
  }

  @_transparent // @_inlineable
  public static var phi: Complex {
    return Complex(real: .phi)
  }

  @_transparent // @_inlineable
  public static func / (lhs: Complex, rhs: Complex) -> Complex {
    // Prevent avoidable overflow; see Numerical Recipes.
    if rhs.real.magnitude >= rhs.imaginary.magnitude {
      let ratio = rhs.imaginary / rhs.real
      let denominator = rhs.real + rhs.imaginary * ratio
      return Complex(
        real: (lhs.real + lhs.imaginary * ratio) / denominator,
        imaginary: (lhs.imaginary - lhs.real * ratio) / denominator
      )
    }
    let ratio = rhs.real / rhs.imaginary
    let denominator = rhs.real * ratio + rhs.imaginary
    return Complex(
      real: (lhs.real * ratio + lhs.imaginary) / denominator,
      imaginary: (lhs.imaginary * ratio - lhs.real) / denominator
    )

    /*
    let denominator = rhs.squaredMagnitude
    return Complex(
      real:
        (lhs.real * rhs.real + lhs.imaginary * rhs.imaginary) / denominator,
      imaginary:
        (lhs.imaginary * rhs.real - lhs.real * rhs.imaginary) / denominator
    )
    */
  }

  @_transparent // @_inlineable
  public static func /= (lhs: inout Complex, rhs: Complex) {
    // Prevent avoidable overflow; see Numerical Recipes.
    let t = lhs.real
    if rhs.real.magnitude >= rhs.imaginary.magnitude {
      let ratio = rhs.imaginary / rhs.real
      let denominator = rhs.real + rhs.imaginary * ratio
      lhs.real = (lhs.real + lhs.imaginary * ratio) / denominator
      lhs.imaginary = (lhs.imaginary - t * ratio) / denominator
    } else {
      let ratio = rhs.real / rhs.imaginary
      let denominator = rhs.real * ratio + rhs.imaginary
      lhs.real = (lhs.real * ratio + lhs.imaginary) / denominator
      lhs.imaginary = (lhs.imaginary * ratio - t) / denominator
    }
  }

  // @_transparent // @_inlineable
  public func naturalExponential() -> Complex {
    if real.isNaN && imaginary == 0 { return self }
    var im = imaginary
    if real.isInfinite {
      if real < 0 && !im.isFinite {
        im = 1
      } else if im == 0 || !im.isFinite {
        if im.isInfinite { im = .nan }
        return Complex(real: real, imaginary: im)
      }
    }
    return Complex(r: T.exp(real), theta: im)
  }

  @_transparent // @_inlineable
  public func naturalLogarithm() -> Complex {
    return Complex(real: T.log(magnitude), imaginary: argument)
  }

  @_transparent // @_inlineable
  public func commonLogarithm() -> Complex {
    return Complex.log(self) / Complex.log(10 as Complex)
  }

  // @_transparent // @_inlineable
  public func squareRoot() -> Complex {
    if imaginary.isInfinite {
      return Complex(real: .infinity, imaginary: imaginary)
    }
    if real.isInfinite {
      if real > 0 {
        return Complex(
          real: real,
          imaginary: imaginary.isNaN ? imaginary :
            T(signOf: imaginary, magnitudeOf: 0)
        )
      }
      return Complex(
        real: imaginary.isNaN ? imaginary : 0,
        imaginary: T(signOf: imaginary, magnitudeOf: real)
      )
    }
    // Guard intermediate results and enforce a branch cut; see Numerical
    // Recipes.
    if real == 0 && imaginary == 0 { return 0 }
    let w: T
    let x = abs(real), y = abs(imaginary)
    if x >= y {
      let r = y / x
      w = T.sqrt(x) * T.sqrt((1 + T.sqrt(1 + r * r)) / 2)
    } else {
      let r = x / y
      w = T.sqrt(y) * T.sqrt((r + T.sqrt(1 + r * r)) / 2)
    }
    if real >= 0 {
      return Complex(real: w, imaginary: imaginary / (2 * w))
    }
    /* real < 0 */
    return Complex(real: y / (2 * w), imaginary: imaginary >= 0 ? w : -w)

    /*
    return Complex(r: T.sqrt(magnitude), theta: argument / 2)
    */
  }

  @_transparent // @_inlineable
  public func cubeRoot() -> Complex {
    return Complex.exp(Complex.log(self) / 3)

    /*
    return Complex(r: T.cbrt(magnitude), theta: argument / 3)
    */
  }

  @_transparent // @_inlineable
  public func power(of base: Complex) -> Complex {
    return Complex.exp(self * Complex.log(base))
  }

  @_transparent // @_inlineable
  public func sine() -> Complex {
    let sinh = Complex.sinh(Complex(real: -imaginary, imaginary: real))
    return Complex(real: sinh.imaginary, imaginary: -sinh.real)
  }

  @_transparent // @_inlineable
  public func cosine() -> Complex {
    return Complex.cosh(Complex(real: -imaginary, imaginary: real))
  }

  @_transparent // @_inlineable
  public func tangent() -> Complex {
    let tanh = Complex.tanh(Complex(real: -imaginary, imaginary: real))
    return Complex(real: tanh.imaginary, imaginary: -tanh.real)
  }

  @_transparent // @_inlineable
  public func inverseSine() -> Complex {
    let asinh = Complex.asinh(Complex(real: -imaginary, imaginary: real))
    return Complex(real: asinh.imaginary, imaginary: -asinh.real)
  }

  // @_transparent // @_inlineable
  public func inverseCosine() -> Complex {
    if real.isNaN {
      if imaginary.isInfinite {
        return Complex(real: real, imaginary: -imaginary)
      }
      return Complex(real: real, imaginary: real)
    }
    if real.isInfinite {
      if imaginary.isNaN {
        return Complex(real: imaginary, imaginary: real)
      }
      if imaginary.isInfinite {
        return Complex(
          real: real < 0 ? .pi * 3 / 4 : .pi / 4,
          imaginary: -imaginary
        )
      }
      return real < 0 ?
        Complex(real: .pi, imaginary: imaginary.sign == .minus ? -real : real) :
        Complex(real: 0, imaginary: imaginary.sign == .minus ? real : -real)
    }
    if real == 0 && (imaginary.isNaN || imaginary == 0) {
      return Complex(real: .pi / 2, imaginary: -imaginary)
    }
    if imaginary.isInfinite {
      return Complex(real: .pi / 2, imaginary: -imaginary)
    }
    let a = Complex.pow(self, 2) - 1
    let b = Complex.log(self + Complex.sqrt(a))
    return Complex(
      real: abs(b.imaginary),
      imaginary: imaginary.sign == .minus ? abs(b.real) : -abs(b.real)
    )
  }

  @_transparent // @_inlineable
  public func inverseTangent() -> Complex {
    let atanh = Complex.atanh(Complex(real: -imaginary, imaginary: real))
    return Complex(real: atanh.imaginary, imaginary: -atanh.real)
  }

  // @_transparent // @_inlineable
  public func hyperbolicSine() -> Complex {
    if (real.isInfinite || real == 0) && !imaginary.isFinite {
      return Complex(real: real, imaginary: .nan)
    }
    if imaginary == 0 && !real.isFinite {
      return self
    }
    return Complex(
      real: T.sinh(real) * T.cos(imaginary),
      imaginary: T.cosh(real) * T.sin(imaginary)
    )
  }

  // @_transparent // @_inlineable
  public func hyperbolicCosine() -> Complex {
    if real.isInfinite && !imaginary.isFinite {
      return Complex(real: abs(real), imaginary: .nan)
    }
    if real == 0 && imaginary == 0 {
      return Complex(real: 1, imaginary: imaginary)
    }
    if real == 0 && !imaginary.isFinite {
      return Complex(real: .nan, imaginary: real)
    }
    if imaginary == 0 && !real.isFinite {
      return Complex(real: abs(real), imaginary: imaginary)
    }
    return Complex(
      real: T.cosh(real) * T.cos(imaginary),
      imaginary: T.sinh(real) * T.sin(imaginary)
    )
  }

  // @_transparent // @_inlineable
  public func hyperbolicTangent() -> Complex {
    if real.isNaN && imaginary == 0 { return self }
    if real.isInfinite {
      if !imaginary.isFinite { return 1 }
      return Complex(
        real: 1, imaginary: T(signOf: T.sin(2 * imaginary), magnitudeOf: 0)
      )
    }
    // See AMS55 4.5.51
    let twiceReal = 2 * real, twiceImaginary = 2 * imaginary
    let denominator = T.cosh(twiceReal) + T.cos(twiceImaginary)
    let sinh = T.sinh(twiceReal)
    if sinh.isInfinite && denominator.isInfinite {
      return Complex(
        real: sinh > 0 ? (1 as T) : -(1 as T),
        imaginary: twiceImaginary > 0 ? (0 as T) : -(0 as T)
      )
    }
    return Complex(
      real: sinh / denominator,
      imaginary: T.sin(twiceImaginary) / denominator
    )
  }

  // @_transparent // @_inlineable
  public func inverseHyperbolicSine() -> Complex {
    if real.isNaN {
      if imaginary.isInfinite {
        return Complex(real: imaginary, imaginary: real)
      }
      if imaginary == 0 { return self }
      return Complex(real: real, imaginary: real)
    }
    if real.isInfinite {
      if imaginary.isNaN { return self }
      if imaginary.isInfinite {
        return Complex(
          real: real, imaginary: T(signOf: imaginary, magnitudeOf: .pi / 4)
        )
      }
      return Complex(
        real: real, imaginary: T(signOf: imaginary, magnitudeOf: 0)
      )
    }
    if imaginary.isInfinite {
      return Complex(
        real: T(signOf: real, magnitudeOf: imaginary),
        imaginary: T(signOf: imaginary, magnitudeOf: .pi / 2)
      )
    }
    let a = Complex.pow(self, 2) + 1
    let b = Complex.log(self + Complex.sqrt(a))
    return Complex(
      real: T(signOf: real, magnitudeOf: b.real),
      imaginary: T(signOf: imaginary, magnitudeOf: b.imaginary)
    )
  }

  // @_transparent // @_inlineable
  public func inverseHyperbolicCosine() -> Complex {
    if real.isNaN {
      if imaginary.isInfinite {
        return Complex(real: .infinity, imaginary: real)
      }
      return Complex(real: real, imaginary: real)
    }
    if real.isInfinite {
      if imaginary.isNaN {
        return Complex(real: .infinity, imaginary: imaginary)
      }
      if imaginary.isInfinite {
        switch (real.sign, imaginary.sign) {
        case (.plus, .plus):
          return Complex(real: .infinity, imaginary: .pi / 4)
        case (.plus, .minus):
          return Complex(real: .infinity, imaginary: -.pi / 4)
        case (.minus, .plus):
          return Complex(real: .infinity, imaginary: .pi * 3 / 4)
        case (.minus, .minus):
          return Complex(real: .infinity, imaginary: -.pi * 3 / 4)
        }
      }
      switch (real.sign, imaginary.sign) {
      case (.plus, .plus):
        return Complex(real: .infinity, imaginary: 0)
      case (.plus, .minus):
        return Complex(real: .infinity, imaginary: -(0 as T))
      case (.minus, .plus):
        return Complex(real: .infinity, imaginary: .pi)
      case (.minus, .minus):
        return Complex(real: .infinity, imaginary: -.pi)
      }
    }
    if imaginary.isNaN {
      // See C11 DR 471.
      return Complex(
        real: imaginary,
        imaginary: real == 0 ? .pi / 2 : imaginary
      )
    }
    if imaginary.isInfinite {
      return Complex(
        real: .infinity, imaginary: T(signOf: imaginary, magnitudeOf: .pi / 2)
      )
    }
    let a = Complex.pow(self, 2) - 1
    let b = Complex.log(self + Complex.sqrt(a))
    return Complex(
      real: T(signOf: 0, magnitudeOf: b.real),
      imaginary: T(signOf: imaginary, magnitudeOf: b.imaginary)
    )
  }

  // @_transparent // @_inlineable
  public func inverseHyperbolicTangent() -> Complex {
    if imaginary.isNaN {
      if real.isInfinite || real == 0 {
        return Complex(
          real: T(signOf: real, magnitudeOf: 0), imaginary: imaginary
        )
      }
      return Complex(real: imaginary, imaginary: imaginary)
    }
    if imaginary.isInfinite {
      return Complex(
        real: T(signOf: real, magnitudeOf: 0),
        imaginary: T(signOf: imaginary, magnitudeOf: .pi / 2)
      )
    }
    if imaginary == 0 && abs(real) == 1 {
      return Complex(
        real: T(signOf: real, magnitudeOf: .infinity),
        imaginary: T(signOf: imaginary, magnitudeOf: 0)
      )
    }
    if real.isNaN {
      return Complex(real: real, imaginary: real)
    }
    if real.isInfinite {
      return Complex(
        real: T(signOf: real, magnitudeOf: 0),
        imaginary: T(signOf: imaginary, magnitudeOf: .pi / 2)
      )
    }
    let a = Complex.log((1 + self) / (1 - self)) / 2
    return Complex(
      real: T(signOf: real, magnitudeOf: a.real),
      imaginary: T(signOf: imaginary, magnitudeOf: a.imaginary)
    )
  }
}

/// Returns the absolute value (magnitude, modulus) of `z`.
@_transparent
public func abs<T>(_ z: Complex<T>) -> Complex<T> {
  return Complex(real: z.magnitude)
}

/// Returns the square root of `z`.
@_transparent
public func sqrt<T>(_ z: Complex<T>) -> Complex<T> {
  return z.squareRoot()
}

public typealias Complex64 = Complex<Float>
public typealias Complex128 = Complex<Double>
