import Foundation
import WorkspaceFeatureInterface
import NetworkCoreInterface

@MainActor
public final class WorkspaceSearchViewModel: ObservableObject {
    @Published public var city: String = ""
    @Published public var spaces: [CoworkingSpace] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public private(set) var hasSearched: Bool = false
    @Published public private(set) var bookedSpaceId: String?

    private let networkClient: NetworkClientType

    public init(networkClient: NetworkClientType) {
        self.networkClient = networkClient
    }

    public func search() {
        let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedCity.isEmpty else {
            errorMessage = "도시를 입력해 주세요."
            return
        }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let endpoint = Endpoint(
                    path: "/v1/workspaces/search",
                    queryItems: [URLQueryItem(name: "city", value: trimmedCity)]
                )
                spaces = try await networkClient.request(endpoint)
                hasSearched = true
            } catch {
                errorMessage = "검색 실패: \(error.localizedDescription)"
                spaces = []
            }
            isLoading = false
        }
    }

    public func bookDayPass(_ space: CoworkingSpace) {
        bookedSpaceId = space.id
    }
}
