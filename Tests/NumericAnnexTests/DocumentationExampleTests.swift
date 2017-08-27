import XCTest
/* @testable */ import NumericAnnex

class DocumentationExampleTests : XCTestCase {
  // It reflects poorly on the project to provide examples that don't compile or
  // give the wrong result, so test them here:
  
  func testReadmeExample() {
    print(2 ** 3)
    // Prints "8".
    XCTAssertEqual("\(2 ** 3)", "8")

    print(4.0 ** 5.0)
    // Prints "1024.0".
    XCTAssertEqual("\(4.0 ** 5.0)", "1024.0")

    print(Int.cbrt(8))
    // Prints "2".
    XCTAssertEqual("\(Int.cbrt(8))", "2")

    print(Double.cbrt(27.0))
    // Prints "3.0".
    XCTAssertEqual("\(Double.cbrt(27.0))", "3.0")

    var x: Ratio = 1 / 4
    // Ratio is a type alias for Rational<Int>.

    print(x.reciprocal())
    // Prints "4".
    XCTAssertEqual("\(x.reciprocal())", "4")

    x *= 8
    print(x + x)
    // Prints "4".
    XCTAssertEqual("\(x + x)", "4")

    x = Ratio(Float.phi) // Golden ratio.
    print(x)
    // Prints "13573053/8388608".
    XCTAssertEqual("\(x)", "13573053/8388608")

    var z: Complex64 = 42 * .i
    // Complex64 is a type alias for Complex<Float>.

    print(Complex.sqrt(z))
    // Prints "4.58258 + 4.58258i".
    XCTAssertEqual("\(Complex.sqrt(z))", "4.58258 + 4.58258i")

    z = .pi + .i * .log(2 - .sqrt(3))
    print(Complex.cos(z).real)
    // Prints "-2.0".
    XCTAssertEqual("\(Complex.cos(z).real)", "-2.0")
  }

  static var allTests = [
    ("testReadmeExample", testReadmeExample),
  ]
}
