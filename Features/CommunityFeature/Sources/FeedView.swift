import SwiftUI
import DesignSystem
import CommunityFeatureInterface

public struct FeedView: View {
    @StateObject private var viewModel: FeedViewModel

    public init(viewModel: FeedViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.posts.isEmpty {
                    ProgressView("피드를 불러오는 중...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage, viewModel.posts.isEmpty {
                    errorView(error)
                } else if viewModel.posts.isEmpty {
                    emptyView
                } else {
                    feedList
                }
            }
            .background(NomadColors.surface)
            .navigationTitle("커뮤니티")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.showCreatePost = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(NomadColors.accent)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showCreatePost) {
                CreatePostView(onPost: { content, category, city, country in
                    viewModel.createPost(content: content, category: category, city: city, country: country)
                })
            }
            .task { await viewModel.loadFeed() }
        }
    }

    private var feedList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.posts) { post in
                    NavigationLink(value: post) {
                        PostCard(post: post, onLike: { viewModel.toggleLike(postId: post.id) })
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .refreshable { await viewModel.loadFeed() }
        .navigationDestination(for: Post.self) { post in
            PostDetailView(post: post)
        }
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(NomadColors.error)
            Text(message)
                .font(NomadFonts.body)
                .foregroundColor(NomadColors.onSurfaceSecondary)
                .multilineTextAlignment(.center)
            NomadButton("다시 시도", style: .outline) {
                Task { await viewModel.loadFeed() }
            }
            .frame(width: 160)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyView: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.3")
                .font(.system(size: 40))
                .foregroundColor(NomadColors.onSurfaceSecondary)
            Text("아직 게시글이 없습니다")
                .font(NomadFonts.body)
                .foregroundColor(NomadColors.onSurfaceSecondary)
            Text("첫 번째 게시글을 작성해 보세요!")
                .font(NomadFonts.caption)
                .foregroundColor(NomadColors.onSurfaceSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PostCard: View {
    let post: Post
    let onLike: () -> Void

    var body: some View {
        NomadCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Circle()
                        .fill(NomadColors.accent.opacity(0.2))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text(String(post.authorName.prefix(1)))
                                .font(NomadFonts.headline)
                                .foregroundColor(NomadColors.accent)
                        )
                    VStack(alignment: .leading, spacing: 2) {
                        Text(post.authorName)
                            .font(NomadFonts.headline)
                        Text("\(post.city), \(post.country)")
                            .font(NomadFonts.caption)
                            .foregroundColor(NomadColors.onSurfaceSecondary)
                    }
                    Spacer()
                    Text(post.category.rawValue)
                        .font(NomadFonts.small)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(NomadColors.highlight.opacity(0.1))
                        .cornerRadius(6)
                }

                Text(post.content)
                    .font(NomadFonts.body)
                    .foregroundColor(NomadColors.onSurface)
                    .lineLimit(4)

                HStack(spacing: 16) {
                    Button(action: onLike) {
                        Label("\(post.likeCount)", systemImage: "heart")
                    }
                    Label("\(post.commentCount)", systemImage: "bubble.right")
                    Spacer()
                }
                .font(NomadFonts.caption)
                .foregroundColor(NomadColors.onSurfaceSecondary)
            }
        }
    }
}
