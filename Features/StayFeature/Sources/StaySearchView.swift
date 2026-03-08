import SwiftUI
import DesignSystem
import TravelDomainInterface

public struct StaySearchView: View {
    @StateObject private var viewModel: StaySearchViewModel

    public init(viewModel: StaySearchViewModel) {
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
            .navigationTitle("숙소 검색")
        }
    }

    private var searchSection: some View {
        NomadCard {
            VStack(spacing: 16) {
                NomadTextField("도시 (예: Bali)", text: $viewModel.city, icon: "building.2")
                HStack(spacing: 12) {
                    VStack(alignment: .leading) {
                        Text("체크인")
                            .font(NomadFonts.caption)
                            .foregroundColor(NomadColors.onSurfaceSecondary)
                        DatePicker("", selection: $viewModel.checkIn, displayedComponents: .date)
                            .labelsHidden()
                    }
                    VStack(alignment: .leading) {
                        Text("체크아웃")
                            .font(NomadFonts.caption)
                            .foregroundColor(NomadColors.onSurfaceSecondary)
                        DatePicker("", selection: $viewModel.checkOut, displayedComponents: .date)
                            .labelsHidden()
                    }
                }
                Stepper("인원: \(viewModel.guests)명", value: $viewModel.guests, in: 1...10)
                    .font(NomadFonts.body)
                NomadButton("숙소 검색", action: viewModel.search)
            }
        }
    }

    @ViewBuilder
    private var statusSection: some View {
        if viewModel.isLoading {
            ProgressView("숙소를 검색 중입니다...")
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
        } else if viewModel.hasSearched && viewModel.stays.isEmpty {
            VStack(spacing: 8) {
                Image(systemName: "bed.double")
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
            ForEach(viewModel.stays) { stay in
                NavigationLink(value: stay) {
                    StayResultCard(stay: stay)
                }
                .buttonStyle(.plain)
            }
        }
        .navigationDestination(for: Stay.self) { stay in
            StayDetailView(
                stay: stay,
                nights: viewModel.numberOfNights,
                onBook: { viewModel.bookStay(stay) }
            )
        }
    }
}

struct StayResultCard: View {
    let stay: Stay

    var body: some View {
        NomadCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(stay.name)
                        .font(NomadFonts.headline)
                        .foregroundColor(NomadColors.onSurface)
                    Spacer()
                    Label("\(stay.rating, specifier: "%.1f")", systemImage: "star.fill")
                        .font(NomadFonts.caption)
                        .foregroundColor(NomadColors.highlight)
                }
                Text("\(stay.city), \(stay.country)")
                    .font(NomadFonts.caption)
                    .foregroundColor(NomadColors.onSurfaceSecondary)
                HStack {
                    Text(stay.type.rawValue.capitalized)
                        .font(NomadFonts.small)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(NomadColors.accent.opacity(0.1))
                        .cornerRadius(6)
                    Text("\(stay.reviewCount) 리뷰")
                        .font(NomadFonts.small)
                        .foregroundColor(NomadColors.onSurfaceSecondary)
                    Spacer()
                    Text("\(stay.currency) \(stay.pricePerNight)/박")
                        .font(NomadFonts.headline)
                        .foregroundColor(NomadColors.accent)
                }
            }
        }
    }
}
