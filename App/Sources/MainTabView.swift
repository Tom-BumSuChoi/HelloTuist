import SwiftUI
import DesignSystem
import FlightFeature
import StayFeature
import WalletFeature
import CommunityFeature
import WorkspaceFeature
import TravelDomainInterface
import PaymentDomainInterface
import NetworkCoreInterface

struct MainTabView: View {
    @State private var selectedTab: Tab = .flights

    private let dependencies: AppDependencies

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    enum Tab: String, CaseIterable {
        case flights = "항공"
        case stays = "숙소"
        case community = "커뮤니티"
        case workspace = "코워킹"
        case wallet = "지갑"

        var icon: String {
            switch self {
            case .flights: return "airplane"
            case .stays: return "bed.double"
            case .community: return "person.3"
            case .workspace: return "desktopcomputer"
            case .wallet: return "creditcard"
            }
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            FlightSearchView(
                viewModel: FlightSearchViewModel(
                    flightSearchUseCase: dependencies.flightSearchUseCase
                )
            )
            .tabItem { Label(Tab.flights.rawValue, systemImage: Tab.flights.icon) }
            .tag(Tab.flights)

            StaySearchView(
                viewModel: StaySearchViewModel(
                    staySearchUseCase: dependencies.staySearchUseCase
                )
            )
            .tabItem { Label(Tab.stays.rawValue, systemImage: Tab.stays.icon) }
            .tag(Tab.stays)

            FeedView(
                viewModel: FeedViewModel(
                    networkClient: dependencies.networkClient
                )
            )
            .tabItem { Label(Tab.community.rawValue, systemImage: Tab.community.icon) }
            .tag(Tab.community)

            WorkspaceSearchView(
                viewModel: WorkspaceSearchViewModel(
                    networkClient: dependencies.networkClient
                )
            )
            .tabItem { Label(Tab.workspace.rawValue, systemImage: Tab.workspace.icon) }
            .tag(Tab.workspace)

            WalletView(
                viewModel: WalletViewModel(
                    exchangeRateUseCase: dependencies.exchangeRateUseCase,
                    splitBillUseCase: dependencies.splitBillUseCase
                )
            )
            .tabItem { Label(Tab.wallet.rawValue, systemImage: Tab.wallet.icon) }
            .tag(Tab.wallet)
        }
        .tint(NomadColors.accent)
    }
}
