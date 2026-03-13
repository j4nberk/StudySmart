// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PDFAnalyzerApp",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    targets: [
        // Core library — contains all models, services, view models and views.
        // Importable by both the app executable and the test target.
        .target(
            name: "PDFAnalyzerAppCore",
            path: "Sources/PDFAnalyzerAppCore"
        ),
        // App entry point — thin executable that just hosts the @main App struct.
        .executableTarget(
            name: "PDFAnalyzerApp",
            dependencies: ["PDFAnalyzerAppCore"],
            path: "Sources/PDFAnalyzerApp"
        ),
        // Tests against the core library.
        .testTarget(
            name: "PDFAnalyzerAppTests",
            dependencies: ["PDFAnalyzerAppCore"],
            path: "Tests/PDFAnalyzerAppTests"
        )
    ]
)
