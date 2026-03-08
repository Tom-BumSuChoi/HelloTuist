import SwiftUI
import WorkspaceFeature
import WorkspaceFeatureTesting
import WorkspaceFeatureInterface
import NetworkCoreInterface

@main
struct WorkspaceExampleApp: App {
    var body: some Scene {
        WindowGroup {
            WorkspaceSearchView(
                viewModel: WorkspaceSearchViewModel(
                    networkClient: PreviewNetworkClient()
                )
            )
        }
    }
}

private final class PreviewNetworkClient: NetworkClientType {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        if let spaces = PreviewWorkspaces.sampleSpaces as? T {
            return spaces
        }
        throw NetworkError.decodingFailed
    }

    func request(_ endpoint: Endpoint) async throws -> Data {
        try JSONEncoder().encode(PreviewWorkspaces.sampleSpaces)
    }
}
