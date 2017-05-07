//
//  Hash.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 4/1/17.
//

// @_versioned
internal func _fnv1a(_ data: AnyHashable...) -> Int {
  let basis, prime: UInt
  switch MemoryLayout<UInt>.size {
  case 4:
    basis = 2166136261
    prime = 16777619
  case 8:
    basis = 14695981039346656037
    prime = 1099511628211
  /*
  case 16:
    basis = 144066263297769815596495629667062367629
    prime = 309485009821345068724781371
  */
  default:
    fatalError("Unsupported UInt bit width for FNV hash")
  }

  let result = data.reduce(basis) { partialResult, element in
    var h = element.hashValue
    return withUnsafeBytes(of: &h) { bytes in
      bytes.reduce(partialResult) { ($0 ^ UInt($1)) &* prime }
    }
  }
  return Int(bitPattern: result)
}
