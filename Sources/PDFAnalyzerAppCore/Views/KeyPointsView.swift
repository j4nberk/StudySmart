import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// Cross-platform clipboard helper
private func copyToClipboard(_ text: String) {
#if canImport(UIKit)
    UIPasteboard.general.string = text
#elseif canImport(AppKit)
    NSPasteboard.general.clearContents()
    NSPasteboard.general.setString(text, forType: .string)
#endif
}

struct KeyPointsView: View {
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        Group {
            if let result = viewModel.analysisResult {
                if result.keyPoints.isEmpty {
                    EmptyResultView(
                        icon: "star",
                        title: "Önemli nokta bulunamadı",
                        subtitle: "Analiz sonucunda önemli nokta üretilmedi. Yeniden analiz etmeyi deneyin."
                    )
                } else {
                    List {
                        Section {
                            ForEach(Array(result.keyPoints.enumerated()), id: \.offset) { index, point in
                                KeyPointRow(index: index + 1, text: point)
                            }
                        } header: {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(.yellow)
                                Text("\(result.keyPoints.count) önemli nokta")
                                    .foregroundStyle(.secondary)
                            }
                            .font(.subheadline)
                            .textCase(nil)
                        }
                    }
                }
            } else {
                EmptyResultView(
                    icon: "star",
                    title: "Henüz analiz yapılmadı",
                    subtitle: "Ana ekrandan belgelerinizi yükleyip analiz edin."
                )
            }
        }
        .navigationTitle("Önemli Noktalar")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

// MARK: - Row

private struct KeyPointRow: View {
    let index: Int
    let text: String
    @State private var isCopied = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.yellow.opacity(0.2))
                    .frame(width: 30, height: 30)
                Text("\(index)")
                    .font(.footnote.bold())
                    .foregroundStyle(.orange)
            }

            Text(text)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onLongPressGesture {
            copyToClipboard(text)
            withAnimation {
                isCopied = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation { isCopied = false }
            }
        }
        .overlay(alignment: .topTrailing) {
            if isCopied {
                Text("Kopyalandı!")
                    .font(.caption2.bold())
                    .padding(4)
                    .background(.green, in: RoundedRectangle(cornerRadius: 4))
                    .foregroundStyle(.white)
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
}
