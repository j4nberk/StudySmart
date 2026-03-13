import SwiftUI

struct ReviewTableView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var searchText = ""

    private var filteredRows: [ReviewTableRow] {
        guard let result = viewModel.analysisResult else { return [] }
        if searchText.isEmpty { return result.reviewTable }
        return result.reviewTable.filter {
            $0.concept.localizedCaseInsensitiveContains(searchText) ||
            $0.explanation.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        Group {
            if let result = viewModel.analysisResult {
                if result.reviewTable.isEmpty {
                    EmptyResultView(
                        icon: "tablecells",
                        title: "Tablo bulunamadı",
                        subtitle: "Analiz sonucunda tekrar tablosu üretilmedi."
                    )
                } else {
                    List {
                        Section {
                            ForEach(filteredRows) { row in
                                ReviewRowView(row: row)
                            }
                        } header: {
                            HStack {
                                Image(systemName: "tablecells.fill")
                                    .foregroundStyle(.blue)
                                Text("\(result.reviewTable.count) kavram")
                                    .foregroundStyle(.secondary)
                            }
                            .font(.subheadline)
                            .textCase(nil)
                        }
                    }
                    .searchable(text: $searchText, prompt: "Kavram ara…")
                }
            } else {
                EmptyResultView(
                    icon: "tablecells",
                    title: "Henüz analiz yapılmadı",
                    subtitle: "Ana ekrandan belgelerinizi yükleyip analiz edin."
                )
            }
        }
        .navigationTitle("Tekrar Tablosu")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

// MARK: - Row

private struct ReviewRowView: View {
    let row: ReviewTableRow
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(row.concept)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if isExpanded {
                Text(row.explanation)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            } else {
                Text(row.explanation)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.3)) {
                isExpanded.toggle()
            }
        }
        .padding(.vertical, 4)
    }
}
