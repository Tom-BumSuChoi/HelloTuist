import SwiftUI
import DesignSystem
import CommunityFeatureInterface

struct CreatePostView: View {
    @State private var content: String = ""
    @State private var category: PostCategory = .travelTip
    @State private var city: String = ""
    @State private var country: String = ""
    @Environment(\.dismiss) private var dismiss

    let onPost: (String, PostCategory, String, String) -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    NomadCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("새 게시글")
                                .font(NomadFonts.title)

                            TextEditor(text: $content)
                                .frame(minHeight: 120)
                                .font(NomadFonts.body)
                                .padding(8)
                                .background(NomadColors.surface)
                                .cornerRadius(8)

                            Picker("카테고리", selection: $category) {
                                ForEach(PostCategory.allCases, id: \.self) { cat in
                                    Text(cat.rawValue).tag(cat)
                                }
                            }
                            .font(NomadFonts.body)

                            NomadTextField("도시", text: $city, icon: "building.2")
                            NomadTextField("나라", text: $country, icon: "globe")
                        }
                    }

                    NomadButton("게시하기") {
                        onPost(content, category, city, country)
                    }
                    .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
            }
            .background(NomadColors.surface)
            .navigationTitle("글쓰기")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") { dismiss() }
                }
            }
        }
    }
}
