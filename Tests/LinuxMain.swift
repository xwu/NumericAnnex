import XCTest
@testable import NumericAnnexTests

XCTMain([
    testCase(ComplexTests.allTests),
    testCase(RationalTests.allTests),
])
