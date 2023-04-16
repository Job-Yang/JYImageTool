// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "JYImageTool",
    products: [
        .library(name: "JYImageTool", targets: ["JYImageTool"])
    ],
    targets: [
        .target(
            name: "JYImageTool",
            dependencies: [],
            path: "JYImageTool",
            exclude: [],
            sources: ["JYImageCore.h", "JYImageCore.m", "JYImageTool.h", "UIImage+JYImageTool.h", "UIImage+JYImageTool.m"],
            publicHeadersPath: "include"
        )
    ]
)
