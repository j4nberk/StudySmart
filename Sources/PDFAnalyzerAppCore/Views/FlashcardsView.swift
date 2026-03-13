import SwiftUI

struct FlashcardsView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var currentIndex = 0
    @State private var isFlipped = false
    @State private var dragOffset: CGFloat = 0

    private var flashcards: [Flashcard] {
        viewModel.analysisResult?.flashcards ?? []
    }

    var body: some View {
        Group {
            if flashcards.isEmpty {
                EmptyResultView(
                    icon: "rectangle.stack",
                    title: "Flaşkart bulunamadı",
                    subtitle: "Analiz sonucunda flaşkart üretilmedi."
                )
            } else {
                VStack(spacing: 0) {
                    // Progress
                    progressBar

                    // Card area
                    ZStack {
                        // Peek at the next card underneath
                        if currentIndex + 1 < flashcards.count {
                            FlashcardCard(
                                card: flashcards[currentIndex + 1],
                                isFlipped: .constant(false),
                                dragOffset: .constant(0)
                            )
                            .scaleEffect(0.95)
                            .offset(y: 10)
                            .allowsHitTesting(false)
                        }

                        // Current card on top
                        if currentIndex < flashcards.count {
                            FlashcardCard(
                                card: flashcards[currentIndex],
                                isFlipped: $isFlipped,
                                dragOffset: $dragOffset
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation.width
                            }
                            .onEnded { value in
                                handleSwipe(translation: value.translation.width)
                            }
                    )

                    // Navigation controls
                    navigationControls
                        .padding(.bottom, 20)
                }
            }
        }
        .navigationTitle("Flaşkartlar")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onChange(of: viewModel.analysisResult) { _, _ in
            currentIndex = 0
            isFlipped = false
        }
    }

    // MARK: - Progress bar

    private var progressBar: some View {
        VStack(spacing: 4) {
            ProgressView(value: Double(currentIndex + 1), total: Double(flashcards.count))
                .tint(.green)
                .padding(.horizontal, 20)
            Text("\(currentIndex + 1) / \(flashcards.count)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 12)
    }

    // MARK: - Navigation

    private var navigationControls: some View {
        HStack(spacing: 32) {
            Button {
                navigate(by: -1)
            } label: {
                Image(systemName: "arrow.left.circle.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(currentIndex > 0 ? .blue : .secondary)
            }
            .disabled(currentIndex == 0)

            Button {
                withAnimation(.spring(response: 0.5)) {
                    isFlipped.toggle()
                }
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 28))
                    Text(isFlipped ? "Soruya Dön" : "Cevabı Gör")
                        .font(.caption.bold())
                }
                .foregroundStyle(.green)
            }

            Button {
                navigate(by: 1)
            } label: {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(currentIndex < flashcards.count - 1 ? .blue : .secondary)
            }
            .disabled(currentIndex >= flashcards.count - 1)
        }
    }

    // MARK: - Helpers

    private func navigate(by delta: Int) {
        let newIndex = currentIndex + delta
        guard newIndex >= 0 && newIndex < flashcards.count else { return }
        withAnimation(.spring(response: 0.4)) {
            isFlipped = false
            dragOffset = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.4)) {
                currentIndex = newIndex
            }
        }
    }

    private func handleSwipe(translation: CGFloat) {
        let threshold: CGFloat = 80
        withAnimation(.spring(response: 0.4)) {
            dragOffset = 0
        }
        if translation < -threshold {
            navigate(by: 1)
        } else if translation > threshold {
            navigate(by: -1)
        }
    }
}

// MARK: - FlashcardCard

private struct FlashcardCard: View {
    let card: Flashcard
    @Binding var isFlipped: Bool
    @Binding var dragOffset: CGFloat

    var body: some View {
        ZStack {
            // Front – question
            cardFace(
                text: card.question,
                label: "SORU",
                systemImage: "questionmark",
                color: .blue
            )
            .opacity(isFlipped ? 0 : 1)
            .rotation3DEffect(.degrees(isFlipped ? -90 : 0), axis: (x: 0, y: 1, z: 0))

            // Back – answer
            cardFace(
                text: card.answer,
                label: "CEVAP",
                systemImage: "checkmark",
                color: .green
            )
            .opacity(isFlipped ? 1 : 0)
            .rotation3DEffect(.degrees(isFlipped ? 0 : 90), axis: (x: 0, y: 1, z: 0))
        }
        .offset(x: dragOffset)
        .onTapGesture {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                isFlipped.toggle()
            }
        }
    }

    private func cardFace(
        text: String,
        label: String,
        systemImage: String,
        color: Color
    ) -> some View {
        VStack(spacing: 16) {
            HStack {
                Label(label, systemImage: systemImage)
                    .font(.caption.bold())
                    .foregroundStyle(color)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(color.opacity(0.15), in: Capsule())
                Spacer()
            }

            Spacer()

            Text(text)
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 8)

            Spacer()

            Text("Kartı çevirmek için dokun")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.background)
                .shadow(color: .black.opacity(0.12), radius: 16, x: 0, y: 6)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(color.opacity(0.3), lineWidth: 1.5)
        )
    }
}
