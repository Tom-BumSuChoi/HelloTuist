import Foundation
import CommunityFeatureInterface

public final class MockCommunityFeatureRouting: CommunityFeatureRouting {
    public var showFeedCallCount = 0
    public var showPostDetailIds: [String] = []
    public var showCreatePostCallCount = 0

    public init() {}

    public func showFeed() { showFeedCallCount += 1 }
    public func showPostDetail(postId: String) { showPostDetailIds.append(postId) }
    public func showCreatePost() { showCreatePostCallCount += 1 }
}

public enum CommunityFixtures {
    public static func makePost(
        id: String = "P001",
        authorName: String = "서연",
        content: String = "치앙마이 님만해민 로드에 새로 생긴 카페 추천!",
        category: PostCategory = .cafe,
        city: String = "Chiang Mai",
        country: String = "Thailand",
        likeCount: Int = 42,
        commentCount: Int = 8
    ) -> Post {
        Post(
            id: id, authorId: "U\(id)", authorName: authorName,
            authorImageURL: nil, content: content, imageURLs: [],
            category: category, city: city, country: country,
            likeCount: likeCount, commentCount: commentCount,
            createdAt: Date()
        )
    }

    public static let samplePosts: [Post] = [
        makePost(),
        makePost(id: "P002", authorName: "Nomad Jake", content: "발리 우붓에서 한 달 살기 중입니다. 같이 저녁 먹을 분 구합니다!", category: .companion, city: "Ubud", country: "Indonesia", likeCount: 28, commentCount: 15),
        makePost(id: "P003", authorName: "MinJi", content: "리스본 LX Factory 근처 코워킹 카페 발견! 인터넷 200Mbps에 커피도 맛있어요.", category: .workspace, city: "Lisbon", country: "Portugal", likeCount: 67, commentCount: 12),
    ]
}
