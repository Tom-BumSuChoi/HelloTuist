import Foundation
import XCTest
@testable import CommunityFeature
import CommunityFeatureTesting
import CommunityFeatureInterface
import NetworkCoreInterface

// MARK: - Test Doubles

private final class StubNetworkClient: NetworkClientType {
    var stubbedResult: Any?
    var stubbedError: Error?
    var requestCallCount = 0

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        requestCallCount += 1
        if let error = stubbedError { throw error }
        guard let result = stubbedResult as? T else { throw NetworkError.decodingFailed }
        return result
    }

    func request(_ endpoint: Endpoint) async throws -> Data {
        requestCallCount += 1
        if let error = stubbedError { throw error }
        return Data()
    }
}

// MARK: - ViewModel Tests

@MainActor
final class FeedViewModelTests: XCTestCase {
    private var networkClient: StubNetworkClient!
    private var sut: FeedViewModel!

    override func setUp() {
        super.setUp()
        networkClient = StubNetworkClient()
        sut = FeedViewModel(networkClient: networkClient)
    }

    func test_initialState() {
        XCTAssertTrue(sut.posts.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.showCreatePost)
        XCTAssertTrue(sut.likedPostIds.isEmpty)
    }

    func test_loadFeed_success() async {
        networkClient.stubbedResult = CommunityFixtures.samplePosts
        await sut.loadFeed()

        XCTAssertEqual(sut.posts.count, 3)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }

    func test_loadFeed_failure_showsError() async {
        networkClient.stubbedError = NetworkError.noData
        await sut.loadFeed()

        XCTAssertTrue(sut.posts.isEmpty)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }

    func test_toggleLike_addsAndRemoves() {
        sut.toggleLike(postId: "P001")
        XCTAssertTrue(sut.likedPostIds.contains("P001"))

        sut.toggleLike(postId: "P001")
        XCTAssertFalse(sut.likedPostIds.contains("P001"))
    }

    func test_createPost_addsToFront() {
        sut.posts = CommunityFixtures.samplePosts
        let initialCount = sut.posts.count

        sut.createPost(content: "새 게시글!", category: .travelTip, city: "Seoul", country: "Korea")

        XCTAssertEqual(sut.posts.count, initialCount + 1)
        XCTAssertEqual(sut.posts[0].content, "새 게시글!")
        XCTAssertEqual(sut.posts[0].city, "Seoul")
        XCTAssertFalse(sut.showCreatePost)
    }

    func test_createPost_emptyContent_doesNotAdd() {
        let initialCount = sut.posts.count
        sut.createPost(content: "  ", category: .travelTip, city: "Seoul", country: "Korea")
        XCTAssertEqual(sut.posts.count, initialCount)
    }
}

// MARK: - Model Tests

final class CommunityModelTests: XCTestCase {
    func test_post_equatable() {
        let a = CommunityFixtures.makePost(id: "P001")
        let b = CommunityFixtures.makePost(id: "P001")
        XCTAssertEqual(a, b)
    }

    func test_postCategory_allCases() {
        XCTAssertEqual(PostCategory.allCases.count, 6)
        XCTAssertTrue(PostCategory.allCases.contains(.restaurant))
        XCTAssertTrue(PostCategory.allCases.contains(.companion))
    }
}

// MARK: - Routing Tests

final class CommunityRoutingTests: XCTestCase {
    func test_mockRouting_tracksAll() {
        let router = MockCommunityFeatureRouting()
        router.showFeed()
        router.showPostDetail(postId: "P001")
        router.showPostDetail(postId: "P002")
        router.showCreatePost()

        XCTAssertEqual(router.showFeedCallCount, 1)
        XCTAssertEqual(router.showPostDetailIds, ["P001", "P002"])
        XCTAssertEqual(router.showCreatePostCallCount, 1)
    }
}
