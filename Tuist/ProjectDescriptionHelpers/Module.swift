import ProjectDescription

public enum Module {
    public static func makeTargets(
        name: String,
        layer: String,
        destinations: Destinations = .iOS,
        dependencies: [TargetDependency] = [],
        interfaceDependencies: [TargetDependency] = [],
        hasResources: Bool = false,
        hasExample: Bool = true
    ) -> [Target] {
        let basePath = "\(layer)/\(name)"
        let bundlePrefix = "io.nomadspace"

        var targets: [Target] = []

        targets.append(.target(
            name: "\(name)Interface",
            destinations: destinations,
            product: .framework,
            bundleId: "\(bundlePrefix).\(name)Interface",
            sources: ["\(basePath)/Interface/**"],
            dependencies: interfaceDependencies
        ))

        targets.append(.target(
            name: name,
            destinations: destinations,
            product: .framework,
            bundleId: "\(bundlePrefix).\(name)",
            sources: ["\(basePath)/Sources/**"],
            resources: hasResources ? ["\(basePath)/Resources/**"] : nil,
            dependencies: [.target(name: "\(name)Interface")] + dependencies
        ))

        targets.append(.target(
            name: "\(name)Testing",
            destinations: destinations,
            product: .framework,
            bundleId: "\(bundlePrefix).\(name)Testing",
            sources: ["\(basePath)/Testing/**"],
            dependencies: [.target(name: "\(name)Interface")]
        ))

        targets.append(.target(
            name: "\(name)Tests",
            destinations: destinations,
            product: .unitTests,
            bundleId: "\(bundlePrefix).\(name)Tests",
            infoPlist: .default,
            sources: ["\(basePath)/Tests/**"],
            dependencies: [
                .target(name: name),
                .target(name: "\(name)Testing"),
            ]
        ))

        if hasExample {
            targets.append(.target(
                name: "\(name)Example",
                destinations: destinations,
                product: .app,
                bundleId: "\(bundlePrefix).\(name)Example",
                infoPlist: .extendingDefault(with: [
                    "UILaunchScreen": ["UIColorName": "", "UIImageName": ""],
                ]),
                sources: ["\(basePath)/Example/Sources/**"],
                dependencies: [
                    .target(name: name),
                    .target(name: "\(name)Testing"),
                ]
            ))
        }

        return targets
    }
}
