import SwiftUI
import DesignSystem
import WorkspaceFeatureInterface

public struct WorkspaceSearchView: View {
    @StateObject private var viewModel: WorkspaceSearchViewModel

    public init(viewModel: WorkspaceSearchViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    searchSection
                    statusSection
                    resultsList
                }
                .padding()
            }
            .background(NomadColors.surface)
            .navigationTitle("코워킹 스페이스")
        }
    }

    private var searchSection: some View {
        HStack(spacing: 8) {
            NomadTextField("도시 검색 (예: Bangkok)", text: $viewModel.city, icon: "magnifyingglass")
            NomadButton("검색") {
                viewModel.search()
            }
            .frame(width: 80)
        }
    }

    @ViewBuilder
    private var statusSection: some View {
        if viewModel.isLoading {
            ProgressView("코워킹 스페이스를 검색 중...")
                .padding(.top, 32)
        } else if let error = viewModel.errorMessage {
            NomadCard {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(NomadColors.error)
                    Text(error)
                        .font(NomadFonts.body)
                        .foregroundColor(NomadColors.error)
                }
            }
        } else if viewModel.hasSearched && viewModel.spaces.isEmpty {
            VStack(spacing: 8) {
                Image(systemName: "desktopcomputer")
                    .font(.system(size: 40))
                    .foregroundColor(NomadColors.onSurfaceSecondary)
                Text("검색 결과가 없습니다")
                    .font(NomadFonts.body)
                    .foregroundColor(NomadColors.onSurfaceSecondary)
            }
            .padding(.top, 32)
        }
    }

    private var resultsList: some View {
        LazyVStack(spacing: 12) {
            ForEach(viewModel.spaces) { space in
                NavigationLink(value: space) {
                    WorkspaceCard(space: space)
                }
                .buttonStyle(.plain)
            }
        }
        .navigationDestination(for: CoworkingSpace.self) { space in
            WorkspaceDetailView(space: space, onBookDayPass: { viewModel.bookDayPass(space) })
        }
    }
}

struct WorkspaceCard: View {
    let space: CoworkingSpace

    var body: some View {
        NomadCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(space.name)
                        .font(NomadFonts.headline)
                        .foregroundColor(NomadColors.onSurface)
                    Spacer()
                    Label("\(space.rating, specifier: "%.1f")", systemImage: "star.fill")
                        .font(NomadFonts.caption)
                        .foregroundColor(NomadColors.highlight)
                }

                Text("\(space.city), \(space.country)")
                    .font(NomadFonts.caption)
                    .foregroundColor(NomadColors.onSurfaceSecondary)

                HStack(spacing: 8) {
                    Label("\(space.wifiSpeed) Mbps", systemImage: "wifi")
                        .font(NomadFonts.small)
                        .foregroundColor(NomadColors.success)
                    Text(space.openingHours)
                        .font(NomadFonts.small)
                        .foregroundColor(NomadColors.onSurfaceSecondary)
                    Spacer()
                    Text("\(space.currency) \(space.dailyPrice)/일")
                        .font(NomadFonts.headline)
                        .foregroundColor(NomadColors.accent)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(space.amenities, id: \.self) { amenity in
                            Text(amenity)
                                .font(NomadFonts.small)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(NomadColors.surface)
                                .cornerRadius(6)
                        }
                    }
                }
            }
        }
    }
}
