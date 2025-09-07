// swift-tools-version:6.1
import PackageDescription

let package = Package(
    name: "SecureChat",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "SecureChat", targets: ["SecureChat"])
    ],
    targets: [
        .executableTarget(
            name: "SecureChat",
            dependencies: [],
            path: "Sources/SecureChat"
        )
    ]
)
