import SwiftUI
import CommunityFeature
import CommunityFeatureTesting
import CommunityFeatureInterface
import NetworkCoreInterface

@main
struct CommunityExampleApp: App {
    var body: some Scene {
        WindowGroup {
            FeedView(
                viewModel: FeedViewModel(
                    networkClient: PreviewNetworkClient()
                )
            )
        }
    }
}

private final class PreviewNetworkClient: NetworkClientType {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        if let posts = PreviewPosts.samplePosts as? T {
            return posts
        }
        throw NetworkError.decodingFailed
    }

    func request(_ endpoint: Endpoint) async throws -> Data {
        try JSONEncoder().encode(PreviewPosts.samplePosts)
    }
}
