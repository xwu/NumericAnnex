//
//  Complex.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 3/25/17.
//

/// A type to represent a complex value in Cartesian form.
///
/// Create new instances of `Complex<T>` using integer or floating-point
/// literals and the imaginary unit `.i`. For example:
///
/// ```swift
/// let x = 2 + 4 * .i // `x` is of type `Complex<Double>`
/// let y = 3.5 + 7 * .i // `y` is of type `Complex<Double>`
///
/// let z: Complex64 = .e + .pi * .i // `z` is of type `Complex<Float>`
/// ```
///
/// Additional Considerations
/// =========================
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
  /// Creates a new value from the given real component, rounded to the closest
  /// possible representation.
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
  // @_transparent // @_inlineable
  public var hashValue: Int {
    return _fnv1a(real, imaginary)
  }
}

public typealias Complex64 = Complex<Float>
public typealias Complex128 = Complex<Double>
