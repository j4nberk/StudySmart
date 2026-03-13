import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var showingSettings = false
    @State private var showingResults = false

    var body: some View {
        NavigationStack {
            DocumentUploadView(showingResults: $showingResults)
                .navigationTitle("PDF Analiz")
                #if os(iOS)
                .navigationBarTitleDisplayMode(.large)
                #endif
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            showingSettings = true
                        } label: {
                            Label("Ayarlar", systemImage: "gear")
                        }
                    }
                }
                .navigationDestination(isPresented: $showingResults) {
                    if viewModel.analysisResult != nil {
                        AnalysisView()
                    }
                }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .onChange(of: viewModel.analysisResult) { _, newValue in
            if newValue != nil {
                showingResults = true
            }
        }
    }
}
