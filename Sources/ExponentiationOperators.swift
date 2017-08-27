//
//  ExponentiationOperators.swift
//  NumericAnnex
//
//  Created by Xiaodi Wu on 8/26/17.
//

precedencegroup ExponentiationPrecedence {
  associativity: right
  higherThan: MultiplicationPrecedence
}

// "Exponentiative"

infix operator ** : ExponentiationPrecedence

// Compound

infix operator **= : AssignmentPrecedence
