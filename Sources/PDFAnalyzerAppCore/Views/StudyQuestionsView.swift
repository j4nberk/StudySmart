import SwiftUI

struct StudyQuestionsView: View {
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        Group {
            if let result = viewModel.analysisResult {
                if result.studyQuestions.isEmpty {
                    EmptyResultView(
                        icon: "questionmark.circle",
                        title: "Soru bulunamadı",
                        subtitle: "Analiz sonucunda çalışma sorusu üretilmedi."
                    )
                } else {
                    List {
                        Section {
                            ForEach(Array(result.studyQuestions.enumerated()), id: \.offset) { index, question in
                                StudyQuestionRow(index: index + 1, question: question)
                            }
                        } header: {
                            HStack {
                                Image(systemName: "questionmark.circle.fill")
                                    .foregroundStyle(.purple)
                                Text("\(result.studyQuestions.count) çalışma sorusu")
                                    .foregroundStyle(.secondary)
                            }
                            .font(.subheadline)
                            .textCase(nil)
                        } footer: {
                            Text("Soruları kendi başınıza cevaplamaya çalışın; ardından notlarınızla karşılaştırın.")
                                .font(.caption)
                        }
                    }
                }
            } else {
                EmptyResultView(
                    icon: "questionmark.circle",
                    title: "Henüz analiz yapılmadı",
                    subtitle: "Ana ekrandan belgelerinizi yükleyip analiz edin."
                )
            }
        }
        .navigationTitle("Çalışma Soruları")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

// MARK: - Row

private struct StudyQuestionRow: View {
    let index: Int
    let question: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.purple.opacity(0.15))
                    .frame(width: 30, height: 30)
                Text("\(index)")
                    .font(.footnote.bold())
                    .foregroundStyle(.purple)
            }

            Text(question)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 4)
    }
}
