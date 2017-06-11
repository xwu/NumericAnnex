//
//  Hash.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 4/1/17.
//

/// A namespace for hash utilities.
internal enum _Hash { }

extension _Hash {
  // @_versioned
  /// Returns the result of combining `seed` with the `hashValue` of the given
  /// `values`.
  ///
  /// Combining is performed using [a hash function][ref] described by T.C. Hoad
  /// and J. Zobel that is also adopted in the Boost C++ libraries.
  ///
  /// [ref]: http://goanna.cs.rmit.edu.au/~jz/fulltext/jasist-tch.pdf
  internal static func _combine(seed: Int = 0, _ values: AnyHashable...) -> Int {
    var x = UInt(bitPattern: seed)
    let magic = 0x9e3779b9 as UInt // Based on the golden ratio.
    for v in values {
      x ^= UInt(bitPattern: v.hashValue) &+ magic &+ (x &<< 6) &+ (x &>> 2)
    }
    return Int(bitPattern: x)
  }
}
