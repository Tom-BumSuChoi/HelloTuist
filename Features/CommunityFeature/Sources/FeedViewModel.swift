import Foundation
import CommunityFeatureInterface
import NetworkCoreInterface

@MainActor
public final class FeedViewModel: ObservableObject {
    @Published public var posts: [Post] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public var showCreatePost: Bool = false
    @Published public private(set) var likedPostIds: Set<String> = []

    private let networkClient: NetworkClientType

    public init(networkClient: NetworkClientType) {
        self.networkClient = networkClient
    }

    public func loadFeed() async {
        isLoading = true
        errorMessage = nil
        do {
            let endpoint = Endpoint(path: "/v1/community/feed")
            posts = try await networkClient.request(endpoint)
        } catch {
            errorMessage = "피드를 불러오지 못했습니다: \(error.localizedDescription)"
        }
        isLoading = false
    }

    public func toggleLike(postId: String) {
        if likedPostIds.contains(postId) {
            likedPostIds.remove(postId)
        } else {
            likedPostIds.insert(postId)
        }
    }

    public func createPost(content: String, category: PostCategory, city: String, country: String) {
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let newPost = Post(
            id: UUID().uuidString,
            authorId: "me",
            authorName: "나",
            authorImageURL: nil,
            content: content,
            imageURLs: [],
            category: category,
            city: city,
            country: country,
            likeCount: 0,
            commentCount: 0,
            createdAt: Date()
        )
        posts.insert(newPost, at: 0)
        showCreatePost = false
    }
}
