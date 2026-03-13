import SwiftUI
import PDFAnalyzerAppCore

@main
struct PDFAnalyzerApp: App {
    @StateObject private var viewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
        #if os(macOS)
        .defaultSize(width: 960, height: 700)
        #endif
    }
}
