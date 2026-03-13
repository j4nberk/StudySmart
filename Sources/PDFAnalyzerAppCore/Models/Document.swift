import Foundation

/// Represents an uploaded document (PDF or presentation) within the app.
struct Document: Identifiable, Equatable {
    let id: UUID
    var name: String
    var url: URL?
    var extractedText: String
    var type: DocumentType

    init(id: UUID = UUID(), name: String, url: URL? = nil, extractedText: String = "", type: DocumentType) {
        self.id = id
        self.name = name
        self.url = url
        self.extractedText = extractedText
        self.type = type
    }

    enum DocumentType {
        /// The reference "past exam questions" document.
        case examQuestions
        /// A study material document (lecture slides, notes, etc.).
        case studyMaterial
    }

    static func == (lhs: Document, rhs: Document) -> Bool {
        lhs.id == rhs.id
    }
}
