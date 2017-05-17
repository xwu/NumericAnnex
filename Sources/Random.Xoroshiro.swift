//
//  Random.Xoroshiro.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 5/16/17.
//

extension Random {
  /// A pseudo-random number generator that implements [`xoroshiro128+`], which
  /// uses a shift/rotate-based linear tranformation devised by Sebastiano Vigna
  /// and David Blackman.
  /* public */ final class Xoroshiro : PRNG {
    public var state: (UInt64, UInt64)

    // TODO: Document this function.
    // @_versioned
    internal static func _rotl(_ value: UInt64, _ count: Int) -> UInt64 {
      return (value &<< count) | (value &>> (64 &- count))
    }

    public func next() -> UInt64? {
      let x = state.0
      var y = state.1
      defer {
        y ^= x
        state.0 = Xoroshiro._rotl(x, 55) ^ y ^ (y &<< 14)
        state.1 = Xoroshiro._rotl(y, 36)
      }
      return x + y
    }

    public init(state: (UInt64, UInt64)) {
      self.state = state
    }

    public init?() {
      repeat {
        guard let entropy = Xoroshiro._entropy(UInt64.self, count: 2) else {
          return nil
        }
        self.state = (entropy[0], entropy[1])
      } while self.state == (0, 0)
    }
  }
}
