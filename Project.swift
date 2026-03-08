import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "NomadSpace",
    targets: appTargets
        + designSystemTargets
        + coreTargets
        + domainTargets
        + featureTargets
)

// MARK: - App Layer

let appTargets: [Target] = [
    .target(
        name: "NomadSpace",
        destinations: .iOS,
        product: .app,
        bundleId: "io.nomadspace.app",
        infoPlist: .extendingDefault(with: [
            "UILaunchScreen": ["UIColorName": "", "UIImageName": ""],
        ]),
        sources: ["App/Sources/**"],
        resources: ["App/Resources/**"],
        dependencies: [
            .target(name: "FlightFeature"),
            .target(name: "StayFeature"),
            .target(name: "WalletFeature"),
            .target(name: "CommunityFeature"),
            .target(name: "WorkspaceFeature"),
            .target(name: "DesignSystem"),
            .target(name: "TravelDomainInterface"),
            .target(name: "PaymentDomainInterface"),
            .target(name: "NetworkCoreInterface"),
        ]
    ),
]

// MARK: - Shared UI Layer

let designSystemTargets: [Target] = [
    .target(
        name: "DesignSystem",
        destinations: .iOS,
        product: .framework,
        bundleId: "io.nomadspace.DesignSystem",
        sources: ["SharedUI/DesignSystem/Sources/**"]
    ),
]

// MARK: - Core Layer

let coreTargets: [Target] =
    Module.makeTargets(
        name: "NetworkCore",
        layer: "Core",
        dependencies: [.external(name: "Alamofire")],
        hasExample: false
    )
    + Module.makeTargets(
        name: "StorageCore",
        layer: "Core",
        hasExample: false
    )
    + Module.makeTargets(
        name: "LoggerUtility",
        layer: "Core",
        hasExample: false
    )

// MARK: - Domain Layer

let domainTargets: [Target] =
    Module.makeTargets(
        name: "TravelDomain",
        layer: "Domains",
        dependencies: [
            .target(name: "NetworkCoreInterface"),
            .target(name: "StorageCoreInterface"),
        ],
        hasExample: false
    )
    + Module.makeTargets(
        name: "PaymentDomain",
        layer: "Domains",
        dependencies: [
            .target(name: "NetworkCoreInterface"),
        ],
        hasExample: false
    )
    + Module.makeTargets(
        name: "AuthDomain",
        layer: "Domains",
        dependencies: [
            .target(name: "NetworkCoreInterface"),
            .target(name: "StorageCoreInterface"),
        ],
        hasExample: false
    )

// MARK: - Feature Layer

let featureTargets: [Target] =
    Module.makeTargets(
        name: "FlightFeature",
        layer: "Features",
        dependencies: [
            .target(name: "TravelDomainInterface"),
            .target(name: "NetworkCoreInterface"),
            .target(name: "DesignSystem"),
        ]
    )
    + Module.makeTargets(
        name: "StayFeature",
        layer: "Features",
        dependencies: [
            .target(name: "TravelDomainInterface"),
            .target(name: "NetworkCoreInterface"),
            .target(name: "DesignSystem"),
        ]
    )
    + Module.makeTargets(
        name: "WalletFeature",
        layer: "Features",
        dependencies: [
            .target(name: "PaymentDomainInterface"),
            .target(name: "NetworkCoreInterface"),
            .target(name: "DesignSystem"),
        ]
    )
    + Module.makeTargets(
        name: "CommunityFeature",
        layer: "Features",
        dependencies: [
            .target(name: "NetworkCoreInterface"),
            .target(name: "DesignSystem"),
        ]
    )
    + Module.makeTargets(
        name: "WorkspaceFeature",
        layer: "Features",
        dependencies: [
            .target(name: "NetworkCoreInterface"),
            .target(name: "DesignSystem"),
        ]
    )
