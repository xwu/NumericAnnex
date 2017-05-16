//
//  Random.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 5/13/17.
//

#if os(Linux)
import Glibc
#else
import Security
#endif

/// A pseudo-random number generator that implements [`xorshift128+`][ref], an
/// efficient linear-feedback shift register.
///
/// [ref]: http://vigna.di.unimi.it/ftp/papers/xorshiftplus.pdf
/* public */ final class Random : PRNG {
  public var state: (UInt64, UInt64)

  public func next() -> UInt64? {
    var x = state.0
    let y = state.1
    state.0 = y
    x ^= x &<< 23
    state.1 = x ^ y ^ (x &>> 17) ^ (y &>> 26)
    return state.1 &+ y
  }

  public init(state: (UInt64, UInt64)) {
    self.state = state
  }

  public init?() {
    let size = MemoryLayout<UInt64>.size
    var state = (0 as UInt64, 0 as UInt64)
    #if os(Linux)
    // Read from `urandom`. See:
    // https://sockpuppet.org/blog/2014/02/25/safely-generate-random-numbers/
    guard let file = fopen("/dev/urandom", "rb") else { return nil }
    defer { fclose(file) }
    repeat {
      let read = withUnsafeMutablePointer(to: &state) {
        fread($0, size, 2, file)
      }
      guard read == 2 else { return nil }
    } while state == (0, 0)
    #else
    // Sandboxing can make `urandom` unavailable.
    let count = size * 2
    repeat {
      let result = withUnsafeMutableBytes(of: &state) {
        SecRandomCopyBytes(
          nil,
          count,
          $0.baseAddress!.bindMemory(to: UInt8.self, capacity: count)
        )
      }
      guard result == errSecSuccess else { return nil }
    } while state == (0, 0)
    #endif
    self.state = state
  }
}
