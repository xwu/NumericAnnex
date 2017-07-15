//
//  Random.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 5/13/17.
//

/// A pseudo-random number generator (PRNG) that implements
/// [`xorshift128+`][ref], an efficient linear-feedback shift register.
///
/// To generate random numbers, create your own instance of `Random` with an
/// internal state seeded from cryptographically secure random bytes:
///
/// ```swift
/// let random = Random()!
/// let x = random.uniform() as Int
///
/// // You can also pass the desired result type as an argument.
/// let y = random.uniform(Int.self)
///
/// if x > y {
///   print("Here's a random value between 0 and 42 (inclusive):")
///   print(random.uniform(0, 42))
/// } else {
///   print("Here's a random value between -42 and 0 (inclusive):")
///   print(random.uniform(-42, 0))
/// }
/// ```
///
/// - Warning: Once seeded from cryptographically secure random bytes, `Random`
///   generates high-quality random numbers but is _not_ a cryptographically
///   secure PRNG.
///
/// - SeeAlso: `Random.Xoroshiro`, `PRNG`
///
/// [ref]: http://vigna.di.unimi.it/ftp/papers/xorshiftplus.pdf
public final class Random : PRNG {
  /// The internal state of the pseudo-random number generator.
  public var state: (UInt64, UInt64)

  /// Creates a pseudo-random number generator with the given internal state.
  ///
  /// - Parameters:
  ///   - state: The value to be used as the generator's internal state.
  public init(state: (UInt64, UInt64)) {
    self.state = state
  }

  /// Creates a pseudo-random number generator with an internal state seeded
  /// using cryptographically secure random bytes.
  ///
  /// If cryptographically secure random bytes are unavailable, the result is
  /// `nil`.
  public convenience init?() {
    self.init(_entropy: Random._entropy(UInt64.self, count: 2))
  }

  /// Creates a pseudo-random number generator with an internal state seeded
  /// using cryptographically secure random bytes.
  ///
  /// If cryptographically secure random bytes are unavailable, the result is
  /// `nil`.
  internal init?(_entropy: @autoclosure () -> [UInt64]?) {
    repeat {
      guard let entropy = _entropy() else { return nil }
      self.state = (entropy[0], entropy[1])
    } while self.state == (0, 0)
  }
  
  public func next() -> UInt64? {
#if true
    // An updated version of xorshift128+.
    //
    // This version adds the two halves of the current state, which allows for
    // better parallelization.
    var x = state.0
    let y = state.1
    let result = x &+ y
    state.0 = y
    x ^= x &<< 23
    state.1 = x ^ y ^ (x &>> 18) ^ (y &>> 5)
    return result
#else
    // A previous version of xorshift128+.
    var x = state.0
    let y = state.1
    state.0 = y
    x ^= x &<< 23
    state.1 = x ^ y ^ (x &>> 17) ^ (y &>> 26)
    return state.1 &+ y
#endif
  }
}
