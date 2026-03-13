import SwiftUI
import UniformTypeIdentifiers

struct DocumentUploadView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Binding var showingResults: Bool

    @State private var showingExamPicker = false
    @State private var showingStudyPicker = false
    @State private var showingErrorAlert = false

    private let pdfType = UTType.pdf

    var body: some View {
        List {
            // MARK: Sınav Soruları
            Section {
                if let doc = viewModel.examQuestionsDocument {
                    DocumentRowView(
                        name: doc.name,
                        subtitle: "\(doc.extractedText.split(separator: " ").count) kelime ayıklandı",
                        systemImage: "doc.text.fill",
                        color: .orange
                    ) {
                        withAnimation {
                            viewModel.examQuestionsDocument = nil
                            viewModel.clearAnalysis()
                        }
                    }
                } else {
                    Button {
                        showingExamPicker = true
                    } label: {
                        Label("PDF Seç…", systemImage: "plus.circle.fill")
                            .foregroundStyle(.orange)
                    }
                }
            } header: {
                Label("Geçmiş Sınav Soruları", systemImage: "list.bullet.clipboard.fill")
            } footer: {
                Text("Bu belge, Gemini'nin hangi konulara odaklanacağını belirlemek için kullanılır.")
                    .font(.caption)
            }

            // MARK: Çalışma Materyalleri
            Section {
                ForEach(viewModel.studyMaterials) { doc in
                    DocumentRowView(
                        name: doc.name,
                        subtitle: "\(doc.extractedText.split(separator: " ").count) kelime",
                        systemImage: "book.fill",
                        color: .blue
                    ) {
                        withAnimation {
                            viewModel.studyMaterials.removeAll { $0.id == doc.id }
                            viewModel.clearAnalysis()
                        }
                    }
                }
                .onDelete { offsets in
                    viewModel.removeStudyMaterials(at: offsets)
                    viewModel.clearAnalysis()
                }

                Button {
                    showingStudyPicker = true
                } label: {
                    Label("PDF Ekle…", systemImage: "plus.circle.fill")
                        .foregroundStyle(.blue)
                }
            } header: {
                Label("Çalışma Materyalleri", systemImage: "books.vertical.fill")
            } footer: {
                Text("Analiz etmek istediğiniz ders notlarını, slaytları veya PDF belgelerini ekleyin.")
                    .font(.caption)
            }

            // MARK: Analiz Butonu
            Section {
                analyzeButton
            }

            // MARK: Hata
            if let error = viewModel.analysisError {
                Section {
                    Label(error, systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(.red)
                        .font(.subheadline)
                }
            }
        }
        .fileImporter(
            isPresented: $showingExamPicker,
            allowedContentTypes: [pdfType],
            allowsMultipleSelection: false
        ) { result in
            handlePickedFile(result: result, isExam: true)
        }
        .fileImporter(
            isPresented: $showingStudyPicker,
            allowedContentTypes: [pdfType],
            allowsMultipleSelection: true
        ) { result in
            handlePickedFile(result: result, isExam: false)
        }
    }

    // MARK: - Analyze button

    @ViewBuilder
    private var analyzeButton: some View {
        if viewModel.isAnalyzing {
            HStack(spacing: 12) {
                ProgressView()
                    .controlSize(.regular)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Analiz ediliyor…")
                        .font(.headline)
                    Text("Gemini belgeleri inceliyor, lütfen bekleyin.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)
        } else {
            Button {
                Task {
                    await viewModel.analyze()
                }
            } label: {
                HStack {
                    Image(systemName: "sparkles")
                    Text(viewModel.analysisResult == nil ? "Analiz Et" : "Yeniden Analiz Et")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(!viewModel.canAnalyze)
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))

            if viewModel.analysisResult != nil {
                Button {
                    showingResults = true
                } label: {
                    HStack {
                        Image(systemName: "eye.fill")
                        Text("Sonuçları Görüntüle")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
            }
        }
    }

    // MARK: - File handling

    private func handlePickedFile(result: Result<[URL], Error>, isExam: Bool) {
        switch result {
        case .success(let urls):
            for url in urls {
                if isExam {
                    viewModel.loadExamQuestionsDocument(from: url)
                } else {
                    viewModel.addStudyMaterial(from: url)
                }
            }
        case .failure(let error):
            viewModel.analysisError = "Dosya seçme hatası: \(error.localizedDescription)"
        }
    }
}

// MARK: - DocumentRowView

private struct DocumentRowView: View {
    let name: String
    let subtitle: String
    let systemImage: String
    let color: Color
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.body)
                    .lineLimit(1)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(role: .destructive, action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 2)
    }
}
