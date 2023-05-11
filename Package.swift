// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
let targets:[Target] = [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    
    .target(
        name: "Feedback", dependencies: []),
    .target(name: "Log", swiftSettings: [.define("ios", .when(platforms: [.iOS]))]),
    .target(name: "FoundationExtensions"),
    .target(name: "Injector"),
    .target(name: "Introspect"),
    .target(name: "NetworkService",
           dependencies: [
            .byName(name:"Log"),
            "FoundationExtensions"
           ]),
    .target(name: "SwiftUIExtensions",
           dependencies: [
            "Log",
            "NetworkService",
            "Feedback",
            "FoundationExtensions",
            "Introspect"
           ]),
    .target(name: "Authorization",
           dependencies: [
            .product(name: "AppAuth", package: "AppAuth-iOS"),
            .product(name: "AppAuthCore", package: "AppAuth-iOS")
            //.byName(name: "AppAuth")
           ])]
let products:[Product] = targets.map{.library(name: $0.name, targets: [$0.name])}
let package = Package(
    name: "CommonModules",
    platforms: [
        .iOS(.v14)
    ],
    products: products,
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/openid/AppAuth-iOS.git", .upToNextMajor(from: "1.6.2"))
//        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.4"))
    ],
    targets: targets)
