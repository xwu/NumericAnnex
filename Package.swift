// swift-tools-version:4.0

import PackageDescription

let package = Package(
  name: "NumericAnnex",
  products: [
    .library(
      name: "NumericAnnex",
      targets: ["NumericAnnex"]
    ),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "NumericAnnex",
      dependencies: [],
      path: "Sources"
    ),
    .testTarget(
      name: "NumericAnnexTests",
      dependencies: ["NumericAnnex"]
    ),
  ]
)
