# PDF Analiz Uygulaması

Gemini API ile desteklenen iOS/macOS uygulaması. Yüklediğiniz slaytlar ve PDF belgelerini, geçmiş sınav sorularınıza göre analiz ederek önemli noktalar, hızlı tekrar tabloları, çalışma soruları ve flaşkartlar üretir.

## Özellikler

| Özellik | Açıklama |
|---|---|
| 📄 **PDF Yükleme** | Sınav soruları ve çalışma materyali PDF'lerini yükleyin |
| ⭐ **Önemli Noktalar** | Sınavda çıkması muhtemel 15 kritik nokta |
| 📋 **Hızlı Tekrar Tablosu** | Kavram → Açıklama formatında özet tablo |
| ❓ **Çalışma Soruları** | Materyale dayalı 10 düşündürücü soru |
| 🃏 **Flaşkartlar** | Dokunarak çevirilen etkileşimli soru/cevap kartları |
| 🔗 **Paylaşım** | Analiz sonuçlarını metin olarak paylaşın |

## Gereksinimler

- **Xcode 15** veya üzeri
- **iOS 17+** veya **macOS 14+** hedef
- **Google Gemini API anahtarı** — [aistudio.google.com](https://aistudio.google.com) adresinden ücretsiz alabilirsiniz

## Kurulum

### 1. Xcode'da Açın

```bash
git clone https://github.com/j4nberk/pdf-analyzer-app.git
cd pdf-analyzer-app
open Package.swift   # Xcode otomatik olarak açılır
```

> **Not:** Xcode, `Package.swift` dosyasını açtığında projeyi otomatik olarak yapılandırır.

### 2. Hedef Seçin

Xcode araç çubuğundan istediğiniz hedefi seçin:
- **iPhone Simülatörü** veya gerçek cihaz
- **My Mac (Designed for iPad)** — Mac'te çalıştırmak için

### 3. Build & Run

`⌘R` ile uygulamayı başlatın.

### 4. API Anahtarı Ekleyin

Uygulama açıldıktan sonra sağ üstteki ⚙️ **Ayarlar** simgesine dokunun ve Gemini API anahtarınızı girin.

## Kullanım

1. **Ayarlar**'dan Gemini API anahtarınızı girin (yalnızca ilk kullanımda gereklidir)
2. **Geçmiş Sınav Soruları** bölümüne sınav soruları PDF'inizi yükleyin
3. **Çalışma Materyalleri** bölümüne ders notları, slaytlar vb. PDF'leri ekleyin (birden fazla eklenebilir)
4. **Analiz Et** butonuna dokunun
5. Sonuçlara dört farklı sekmeden ulaşın:
   - **Önemli Noktalar** — Madde madde kritik bilgiler
   - **Tekrar Tablosu** — Kavram → Açıklama özet tablosu (arama destekli)
   - **Çalışma Soruları** — Sınav tarzı sorular
   - **Flaşkartlar** — Sola/sağa kaydırarak veya ok tuşlarıyla geçin, karta dokunarak çevirin

## Proje Yapısı

```
Sources/PDFAnalyzerApp/
├── PDFAnalyzerApp.swift          # Uygulama giriş noktası (@main)
├── ContentView.swift             # Ana ekran
├── Models/
│   ├── AnalysisResult.swift      # Analiz sonuç modeli (JSON kodlanabilir)
│   ├── AppError.swift            # Özel hata türleri
│   └── Document.swift            # Belge modeli
├── Services/
│   ├── GeminiService.swift       # Gemini REST API istemcisi
│   └── PDFService.swift          # PDFKit tabanlı metin ayıklayıcı
├── ViewModels/
│   └── AppViewModel.swift        # Merkezi durum yöneticisi (@MainActor)
└── Views/
    ├── AnalysisView.swift        # Sekmeli sonuç ekranı
    ├── DocumentUploadView.swift  # Belge yükleme ekranı
    ├── EmptyResultView.swift     # Boş durum görünümü
    ├── FlashcardsView.swift      # Etkileşimli flaşkart ekranı
    ├── KeyPointsView.swift       # Önemli noktalar listesi
    ├── ReviewTableView.swift     # Hızlı tekrar tablosu
    ├── SettingsView.swift        # API anahtarı ve model ayarları
    └── StudyQuestionsView.swift  # Çalışma soruları listesi
```

## Kullanılan Model Seçenekleri

| Model | Hız | Kalite | Kullanım |
|---|---|---|---|
| `gemini-2.0-flash` | ⚡ Hızlı | ✅ Yüksek | Varsayılan — çoğu belge için ideal |
| `gemini-1.5-flash` | ⚡ Hızlı | ✅ İyi | Dengeli seçenek |
| `gemini-1.5-pro` | 🐢 Yavaş | 🏆 En yüksek | Karmaşık belgeler için |

## Güvenlik

- API anahtarı `UserDefaults` içinde saklanır (geliştirme ortamı içindir).
- Üretim uygulamaları için API anahtarını iOS **Keychain** veya bir arka uç proxy üzerinden saklayın.
- PDF metni yalnızca Gemini API'ye iletilir; başka bir sunucuya gönderilmez.

## Testler

```bash
swift test
```

Testler; model kodlama/çözme, hata mesajları ve API yanıt ayrıştırma mantığını kapsar.

## Lisans

MIT
