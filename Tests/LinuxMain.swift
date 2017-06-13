import XCTest
@testable import NumericAnnexTests

XCTMain([
  testCase(ExponentiationTests.allTests),
  testCase(FactoringTests.allTests),
  testCase(RealTests.allTests),
  testCase(RationalTests.allTests),
  testCase(ComplexTests.allTests),
  testCase(RandomXorshiftTests.allTests),
  testCase(RandomXoroshiroTests.allTests),
])
