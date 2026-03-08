import Foundation

public struct Post: Codable, Equatable, Identifiable {
    public let id: String
    public let authorId: String
    public let authorName: String
    public let authorImageURL: String?
    public let content: String
    public let imageURLs: [String]
    public let category: PostCategory
    public let city: String
    public let country: String
    public let likeCount: Int
    public let commentCount: Int
    public let createdAt: Date

    public init(
        id: String, authorId: String, authorName: String, authorImageURL: String?,
        content: String, imageURLs: [String], category: PostCategory,
        city: String, country: String,
        likeCount: Int, commentCount: Int, createdAt: Date
    ) {
        self.id = id
        self.authorId = authorId
        self.authorName = authorName
        self.authorImageURL = authorImageURL
        self.content = content
        self.imageURLs = imageURLs
        self.category = category
        self.city = city
        self.country = country
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.createdAt = createdAt
    }
}

public enum PostCategory: String, Codable, CaseIterable {
    case restaurant
    case cafe
    case travelTip
    case companion
    case accommodation
    case workspace
}

public protocol CommunityFeatureRouting {
    func showFeed()
    func showPostDetail(postId: String)
    func showCreatePost()
}
