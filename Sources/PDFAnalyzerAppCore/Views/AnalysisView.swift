import SwiftUI

struct AnalysisView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            KeyPointsView()
                .tabItem {
                    Label("Önemli Noktalar", systemImage: "star.fill")
                }
                .tag(0)

            ReviewTableView()
                .tabItem {
                    Label("Tekrar Tablosu", systemImage: "tablecells.fill")
                }
                .tag(1)

            StudyQuestionsView()
                .tabItem {
                    Label("Çalışma Soruları", systemImage: "questionmark.circle.fill")
                }
                .tag(2)

            FlashcardsView()
                .tabItem {
                    Label("Flaşkartlar", systemImage: "rectangle.stack.fill")
                }
                .tag(3)
        }
        .navigationTitle("Analiz Sonuçları")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                ShareButton()
            }
        }
    }
}

// MARK: - Share button

private struct ShareButton: View {
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        if let result = viewModel.analysisResult {
            ShareLink(item: buildShareText(result: result)) {
                Image(systemName: "square.and.arrow.up")
            }
        }
    }

    private func buildShareText(result: AnalysisResult) -> String {
        var lines: [String] = []

        lines.append("📚 PDF ANALİZ SONUÇLARI")
        lines.append(String(repeating: "=", count: 40))

        lines.append("\n⭐ ÖNEMLİ NOKTALAR")
        for (i, point) in result.keyPoints.enumerated() {
            lines.append("\(i + 1). \(point)")
        }

        lines.append("\n📋 HIZLI TEKRAR TABLOSU")
        for row in result.reviewTable {
            lines.append("• \(row.concept): \(row.explanation)")
        }

        lines.append("\n❓ ÇALIŞMA SORULARI")
        for (i, q) in result.studyQuestions.enumerated() {
            lines.append("\(i + 1). \(q)")
        }

        lines.append("\n🃏 FLAŞKARTLAR")
        for (i, card) in result.flashcards.enumerated() {
            lines.append("S\(i + 1): \(card.question)")
            lines.append("C\(i + 1): \(card.answer)")
        }

        return lines.joined(separator: "\n")
    }
}
