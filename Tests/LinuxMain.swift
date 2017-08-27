import XCTest
@testable import NumericAnnexTests

XCTMain([
  testCase(DocumentationExampleTests.allTests),
  testCase(ExponentiationTests.allTests),
  testCase(RootExtractionTests.allTests),
  testCase(FactoringTests.allTests),
  testCase(RealTests.allTests),
  testCase(RationalTests.allTests),
  testCase(ComplexTests.allTests),
  testCase(RandomXorshiftTests.allTests),
  testCase(RandomXoroshiroTests.allTests),
])
