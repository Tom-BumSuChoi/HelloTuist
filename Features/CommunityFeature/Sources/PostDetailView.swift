import SwiftUI
import DesignSystem
import CommunityFeatureInterface

struct PostDetailView: View {
    let post: Post

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                authorSection
                contentSection
                statsSection
            }
            .padding()
        }
        .background(NomadColors.surface)
        .navigationTitle("게시글")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var authorSection: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(NomadColors.accent.opacity(0.2))
                .frame(width: 48, height: 48)
                .overlay(
                    Text(String(post.authorName.prefix(1)))
                        .font(NomadFonts.title)
                        .foregroundColor(NomadColors.accent)
                )
            VStack(alignment: .leading, spacing: 4) {
                Text(post.authorName)
                    .font(NomadFonts.headline)
                    .foregroundColor(NomadColors.onSurface)
                HStack(spacing: 4) {
                    Image(systemName: "mappin")
                    Text("\(post.city), \(post.country)")
                }
                .font(NomadFonts.caption)
                .foregroundColor(NomadColors.onSurfaceSecondary)
            }
            Spacer()
            Text(post.category.rawValue)
                .font(NomadFonts.small)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(NomadColors.highlight.opacity(0.1))
                .cornerRadius(8)
        }
    }

    private var contentSection: some View {
        NomadCard {
            Text(post.content)
                .font(NomadFonts.body)
                .foregroundColor(NomadColors.onSurface)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var statsSection: some View {
        HStack(spacing: 24) {
            Label("\(post.likeCount) 좋아요", systemImage: "heart.fill")
                .foregroundColor(NomadColors.error)
            Label("\(post.commentCount) 댓글", systemImage: "bubble.right.fill")
                .foregroundColor(NomadColors.accent)
            Spacer()
        }
        .font(NomadFonts.body)
    }
}
