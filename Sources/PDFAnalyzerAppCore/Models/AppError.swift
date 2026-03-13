import Foundation

// MARK: - Custom errors

enum AppError: LocalizedError {
    case noAPIKey
    case noExamDocument
    case noStudyMaterials
    case pdfExtractionFailed(String)
    case apiError(String)
    case responseParsingFailed(String)
    case networkError(String)

    var errorDescription: String? {
        switch self {
        case .noAPIKey:
            return "Gemini API anahtarı girilmemiş. Lütfen Ayarlar ekranından API anahtarınızı girin."
        case .noExamDocument:
            return "Sınav soruları belgesi yüklenmemiş. Lütfen önce geçmiş sınav sorularınızı yükleyin."
        case .noStudyMaterials:
            return "Çalışma materyali yüklenmemiş. Lütfen analiz etmek istediğiniz PDF veya slaytları yükleyin."
        case .pdfExtractionFailed(let detail):
            return "PDF'den metin çıkarılamadı: \(detail)"
        case .apiError(let message):
            return "Gemini API hatası: \(message)"
        case .responseParsingFailed(let detail):
            return "API yanıtı işlenemedi: \(detail)"
        case .networkError(let message):
            return "Ağ hatası: \(message)"
        }
    }
}
