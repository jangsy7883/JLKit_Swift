# JLKit

## Swift Package Manager

### Xcode

1. In Xcode, select **File > Add Package Dependencies...**
2. Enter:
   - `https://github.com/jangsy7883/JLKit_Swift.git`
3. Choose a version rule (for example, **Up to Next Major**)
4. Add product:
   - `JLKit_Swift`

### Package.swift

```swift
dependencies: [
    .package(url: "https://github.com/jangsy7883/JLKit_Swift.git", from: "0.0.101")
]
```

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "JLKit_Swift", package: "JLKit_Swift")
        ]
    )
]
```

## Release For SPM

SPM uses git tags. Create and push a new semantic version tag when releasing:

```bash
git tag 0.0.101
git push origin main --tags
```
