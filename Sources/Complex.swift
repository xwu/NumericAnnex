//
//  Complex.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 3/25/17.
//

/// A type to represent a complex value in Cartesian form.
// @_fixed_layout
public struct Complex<
  T : FloatingPointMath & _ExpressibleByBuiltinFloatLiteral
> {
  /// The real component of the complex value.
  public var real: T

  /// The imaginary component of the complex value.
  public var imaginary: T

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

  /// The imaginary unit i.
  @_transparent // @_inlineable
  public static var i: Complex {
    return Complex(real: 0, imaginary: 1)
  }
}

extension Complex {
  /// Creates a new value from the given real component.
  ///
  /// - Parameters:
  ///   - real: The new value's real component.
  @_transparent // @_inlineable
  init(_ real: T) {
    self.real = real
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

  // FIXME: If protocol requirements are added to FloatingPoint
  // add init(_: Float) and friends, as well as init?(exactly:).
}

extension Complex {
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

  /// The complex conjugate of this value, obtained by reversing the sign of the
  /// imaginary component.
  @_transparent // @_inlineable
  public func conjugate() -> Complex {
    return Complex(real: real, imaginary: -imaginary)
  }

  /// The polar coordinates representing this value, equivalent to
  /// `(magnitude, argument)`.
  @_transparent // @_inlineable
  public func polar() -> (r: T, theta: T) {
    return (magnitude, argument)
  }

  /// The projection of this value onto the Riemann sphere.
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

  /// The reciprocal (multiplicative inverse) of this value.
  @_transparent // @_inlineable
  public func reciprocal() -> Complex {
    let denominator = squaredMagnitude
    return Complex(
      real: real / denominator, imaginary: -imaginary / denominator
    )
  }
}

extension Complex : ExpressibleByFloatLiteral {
  @_transparent // @_inlineable
  public init(floatLiteral value: T) {
    self.real = value
    self.imaginary = 0
  }
}

extension Complex : ExpressibleByIntegerLiteral {
  @_transparent // @_inlineable
  public init(integerLiteral value: Int) {
    self.real = T(value)
    self.imaginary = 0
  }
}

extension Complex : CustomStringConvertible {
  @_transparent // @_inlineable
  public var description: String {
    return "\(real) + \(imaginary)i"
  }
}

extension Complex : Equatable {
  @_transparent // @_inlineable
  public static func == (lhs: Complex, rhs: Complex) -> Bool {
    return lhs.real == rhs.real && lhs.imaginary == rhs.imaginary
  }
}

extension Complex : Hashable {
  @_transparent // @_inlineable
  public var hashValue: Int {
    return _fnv1a(real, imaginary)
  }
}

public typealias Complex64 = Complex<Float>
public typealias Complex128 = Complex<Double>

/// Returns the absolute value (magnitude, modulus) of `z`.
@_transparent
public func abs<T>(_ z: Complex<T>) -> Complex<T> {
  return Complex(real: z.magnitude)
}
