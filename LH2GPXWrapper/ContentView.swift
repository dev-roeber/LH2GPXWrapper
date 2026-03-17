import SwiftUI
import LocationHistoryConsumerAppSupport
import LocationHistoryConsumerDemoSupport
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var session = AppSessionState()
    @State private var isImportingFile = false

    var body: some View {
        Group {
            if session.content != nil {
                AppContentSplitView(session: $session)
            } else if session.isLoading {
                ProgressView("Opening app export...")
            } else {
                emptyStateView
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    isImportingFile = true
                } label: {
                    Label(openButtonTitle, systemImage: "doc.badge.plus")
                }
                Button {
                    loadBundledDemo()
                } label: {
                    Label(demoButtonTitle, systemImage: "testtube.2")
                }
                if session.hasLoadedContent || session.message?.kind == .error {
                    Button {
                        clearCurrentContent()
                    } label: {
                        Label("Clear", systemImage: "xmark.circle")
                    }
                }
            }
        }
        .fileImporter(
            isPresented: $isImportingFile,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false,
            onCompletion: handleImportResult
        )
        .task {
            restoreBookmarkedFile()
        }
    }

    private var emptyStateView: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Import your location history")
                    .font(.title2.weight(.semibold))
                Text("Open a local app_export.json file created with the LocationHistory2GPX tool to explore your location history offline.")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            AppSourceSummaryCard(summary: session.sourceSummary)

            if let message = session.message, message.kind == .error {
                AppMessageCard(message: message)
            }

            VStack(alignment: .leading, spacing: 10) {
                Button {
                    isImportingFile = true
                } label: {
                    Label("Open app_export.json", systemImage: "doc.badge.plus")
                }
                .buttonStyle(.borderedProminent)
                Button(action: loadBundledDemo) {
                    Label("Load Demo Data", systemImage: "testtube.2")
                }
                .buttonStyle(.bordered)
                if session.message?.kind == .error {
                    Button(action: clearCurrentContent) {
                        Label("Clear", systemImage: "xmark.circle")
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .frame(maxWidth: 520, alignment: .leading)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
    }

    private var openButtonTitle: String {
        session.hasLoadedContent ? "Open Another File" : "Open app_export.json"
    }

    private var demoButtonTitle: String {
        session.source == .demoFixture(name: AppContentLoader.defaultDemoFixtureName)
            ? "Reload Demo" : "Demo Data"
    }

    private func loadBundledDemo() {
        ImportBookmarkStore.clear()
        session.beginLoading()
        do {
            session.show(content: try DemoDataLoader.loadDefaultContent())
        } catch {
            session.showFailure(
                title: "Unable to load demo data",
                message: error.localizedDescription,
                preserveCurrentContent: session.hasLoadedContent
            )
        }
    }

    private func clearCurrentContent() {
        ImportBookmarkStore.clear()
        session.clearContent()
    }

    private func restoreBookmarkedFile() {
        guard !session.hasLoadedContent, !session.isLoading else { return }
        guard let url = ImportBookmarkStore.restore() else { return }
        session.beginLoading()
        let accessedSecurityScope = url.startAccessingSecurityScopedResource()
        defer {
            if accessedSecurityScope {
                url.stopAccessingSecurityScopedResource()
            }
        }
        do {
            session.show(content: try AppContentLoader.loadImportedContent(from: url))
        } catch {
            ImportBookmarkStore.clear()
            session.showFailure(
                title: "Unable to restore previous import",
                message: error.localizedDescription,
                preserveCurrentContent: false
            )
        }
    }

    private func handleImportResult(_ result: Result<[URL], Error>) {
        switch result {
        case let .success(urls):
            guard let url = urls.first else { return }
            session.beginLoading()
            loadImportedFile(at: url)
        case let .failure(error):
            let nsError = error as NSError
            if nsError.domain == NSCocoaErrorDomain && nsError.code == NSUserCancelledError {
                return
            }
            session.showFailure(
                title: "Unable to open app export",
                message: error.localizedDescription,
                preserveCurrentContent: session.hasLoadedContent
            )
        }
    }

    private func loadImportedFile(at url: URL) {
        let accessedSecurityScope = url.startAccessingSecurityScopedResource()
        defer {
            if accessedSecurityScope {
                url.stopAccessingSecurityScopedResource()
            }
        }
        do {
            let content = try AppContentLoader.loadImportedContent(from: url)
            ImportBookmarkStore.save(url: url)
            session.show(content: content)
        } catch {
            session.showFailure(
                title: "Unable to open app export",
                message: error.localizedDescription,
                preserveCurrentContent: session.hasLoadedContent
            )
        }
    }
}
