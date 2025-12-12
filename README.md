# Event Reminder – Arsitektur & Struktur Folder

Proyek ini menggunakan pendekatan modular berbasis fitur dengan lapisan core untuk utilitas bersama.

## Struktur utama
- `lib/main.dart` – bootstrap app, inisialisasi notifikasi, locale, dan provider.
- `lib/app.dart` – konfigurasi `MaterialApp`, tema, lokalization, navigator.
- `lib/core/` – kode reusable:
  - `services/notification_service.dart` – inisialisasi dan penjadwalan notifikasi lokal (timezone-aware).
  - `storage/event_storage.dart` – persistensi ringan memakai `SharedPreferences`.
- `lib/features/events/` – modul fitur Event:
  - `models/event_model.dart` – entitas event (id UUID, tanggal, lokasi, catatan, warna kategori).
  - `repositories/event_repository.dart` – jembatan storage + notifikasi.
  - `presentation/providers/event_provider.dart` – state management (ChangeNotifier) untuk CRUD, filter tanggal, dan trigger notifikasi.
  - `presentation/pages/` – UI layar:
    - `home_page.dart` – kalender bulanan + daftar event harian.
    - `event_form_page.dart` – form tambah/ubah event, pilih tanggal/jam dan warna.
  - `presentation/widgets/` – komponen UI (kartu event, pemilih warna).

## Alur singkat
1. App start → `NotificationService.init()` → `EventProvider` disiapkan.
2. `EventProvider.load()` membaca event tersimpan, menampilkan di kalender/list.
3. Tambah/ubah event → simpan ke storage + jadwalkan notifikasi (`flutter_local_notifications`).
4. Hapus event → hapus dari storage + batalkan notifikasi.

## Dependensi utama
- `provider` (state management), `table_calendar` (kalender bulanan), `shared_preferences` (persistensi), `flutter_local_notifications` + `timezone` (notifikasi terjadwal), `intl` (format tanggal), `uuid` (id unik).
