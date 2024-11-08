// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "DrayFireEditor",
    platforms: [
        .iOS(.v16)  // Specifica la versione minima di iOS supportata
    ],
    products: [
        .library(
            name: "DrayFireEditor",
            targets: ["DrayFireEditor"]
        ),
    ],
    dependencies: [
        // Qui puoi aggiungere dipendenze esterne come Swift Packages
    ],
    targets: [
        .target(
            name: "DrayFireEditor",
            dependencies: []
        ),
        .testTarget(
            name: "DrayFireEditorTests",
            dependencies: ["DrayFireEditor"]
        ),
    ]
)
