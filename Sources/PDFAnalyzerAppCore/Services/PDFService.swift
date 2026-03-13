import PDFKit
import Foundation

/// Extracts plain text from PDF files using PDFKit.
struct PDFService {

    /// Extracts all text from the PDF at `url`.
    /// - Returns: The extracted text, or throws if the document cannot be read.
    func extractText(from url: URL) throws -> String {
        guard let pdfDocument = PDFDocument(url: url) else {
            throw AppError.pdfExtractionFailed("Dosya açılamadı: \(url.lastPathComponent)")
        }

        guard pdfDocument.pageCount > 0 else {
            throw AppError.pdfExtractionFailed("PDF boş veya okunamıyor: \(url.lastPathComponent)")
        }

        var fullText = ""
        for pageIndex in 0 ..< pdfDocument.pageCount {
            guard let page = pdfDocument.page(at: pageIndex) else { continue }
            if let pageText = page.string {
                fullText += pageText + "\n\n"
            }
        }

        let trimmed = fullText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            throw AppError.pdfExtractionFailed(
                "\(url.lastPathComponent) dosyasından metin çıkarılamadı. " +
                "Dosya taranmış/görüntü tabanlı bir PDF olabilir."
            )
        }

        return trimmed
    }

    /// Extracts text from in-memory PDF data.
    func extractText(from data: Data, filename: String = "Belge") throws -> String {
        guard let pdfDocument = PDFDocument(data: data) else {
            throw AppError.pdfExtractionFailed("Veri geçerli bir PDF değil: \(filename)")
        }

        guard pdfDocument.pageCount > 0 else {
            throw AppError.pdfExtractionFailed("PDF boş veya okunamıyor: \(filename)")
        }

        var fullText = ""
        for pageIndex in 0 ..< pdfDocument.pageCount {
            guard let page = pdfDocument.page(at: pageIndex) else { continue }
            if let pageText = page.string {
                fullText += pageText + "\n\n"
            }
        }

        let trimmed = fullText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            throw AppError.pdfExtractionFailed(
                "\(filename) dosyasından metin çıkarılamadı. " +
                "Dosya taranmış/görüntü tabanlı bir PDF olabilir."
            )
        }

        return trimmed
    }
}
