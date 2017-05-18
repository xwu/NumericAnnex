//
//  Random.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 5/13/17.
//

/// A pseudo-random number generator that implements [`xorshift128+`][ref], an
/// efficient linear-feedback shift register.
///
/// [ref]: http://vigna.di.unimi.it/ftp/papers/xorshiftplus.pdf
/* public */ final class Random : PRNG {
  public var state: (UInt64, UInt64)

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

  public init(state: (UInt64, UInt64)) {
    self.state = state
  }

  public init?() {
    repeat {
      guard let entropy = Random._entropy(UInt64.self, count: 2) else {
        return nil
      }
      self.state = (entropy[0], entropy[1])
    } while self.state == (0, 0)
  }
}
