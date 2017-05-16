//
//  Random.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 5/13/17.
//

#if os(Linux)
import Glibc
#else
import Darwin
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
    guard let file = fopen("/dev/urandom", "rb") else { return nil }
    defer { fclose(file) }
    let size = MemoryLayout<UInt64>.size
    var read = 0, state = (0 as UInt64, 0 as UInt64)
    repeat {
      withUnsafeMutablePointer(to: &state) { read = fread($0, size, 2, file) }
      guard read == 2 else { return nil }
    } while state == (0, 0)
    self.state = state
  }
}
