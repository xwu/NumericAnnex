import XCTest
@testable import NumericAnnexTests

XCTMain([
  testCase(FactoringTests.allTests),
  testCase(RationalTests.allTests),
  testCase(ComplexTests.allTests),
])
