import Foundation
import TravelDomainInterface

@MainActor
public final class StaySearchViewModel: ObservableObject {
    @Published public var city: String = ""
    @Published public var checkIn: Date = Date()
    @Published public var checkOut: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @Published public var guests: Int = 1
    @Published public var stays: [Stay] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public private(set) var hasSearched: Bool = false
    @Published public private(set) var bookedStayId: String?

    private let staySearchUseCase: StaySearchUseCaseType

    public init(staySearchUseCase: StaySearchUseCaseType) {
        self.staySearchUseCase = staySearchUseCase
    }

    public var numberOfNights: Int {
        max(1, Calendar.current.dateComponents([.day], from: checkIn, to: checkOut).day ?? 1)
    }

    public func search() {
        let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedCity.isEmpty else {
            errorMessage = "도시를 입력해 주세요."
            return
        }
        guard checkOut > checkIn else {
            errorMessage = "체크아웃 날짜는 체크인 이후여야 합니다."
            return
        }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                stays = try await staySearchUseCase.searchStays(
                    city: trimmedCity,
                    checkIn: checkIn,
                    checkOut: checkOut,
                    guests: guests
                )
                hasSearched = true
            } catch {
                errorMessage = "숙소 검색에 실패했습니다: \(error.localizedDescription)"
                stays = []
            }
            isLoading = false
        }
    }

    public func bookStay(_ stay: Stay) {
        bookedStayId = stay.id
    }
}
