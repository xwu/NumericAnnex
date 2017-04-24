import XCTest
@testable import NumericAnnexTests

XCTMain([
  testCase(ComplexTests.allTests),
  testCase(FactoringTests.allTests),
  testCase(RationalTests.allTests),
])
