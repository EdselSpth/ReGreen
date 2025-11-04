# ReGreen

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

> Aplikasi ReGreen — sistem digital pengelolaan sampah dan penarikan keuntungan berbasis Flutter.  
> Dibuat sebagai proyek kolaboratif mahasiswa **Telkom University** untuk mendukung *Smart & Green Environment* 🌱

---

## Deskripsi Proyek

**ReGreen** adalah aplikasi yang membantu masyarakat untuk:
- Mengelola dan menjadwalkan **pengambilan sampah**.
- Mencatat dan memantau **saldo keuntungan hasil daur ulang**.
- Melakukan **penarikan keuntungan** dengan mudah.
- Mendukung gaya hidup **ramah lingkungan dan berkelanjutan**.

Aplikasi ini dirancang dengan tampilan **modern, ramah pengguna, dan responsif**, memanfaatkan **Flutter framework** agar dapat berjalan di berbagai platform (Android, iOS, dan Web).

---

## Fitur Utama

✅ **Autentikasi Pengguna** – Halaman login & profil pengguna  
✅ **Dashboard Utama** – Menampilkan saldo, jadwal pengambilan, dan aksi cepat  
✅ **Penarikan Keuntungan** – Fitur untuk menarik saldo hasil pengelolaan sampah  
✅ **Jadwal Pengambilan** – Informasi kurir, jenis sampah, dan status penjemputan  
✅ **Profil & Edit Profil** – Menampilkan dan mengubah data pengguna  
✅ **Navigasi Bawah (Bottom Navigation Bar)** – Akses cepat antar halaman

---

## Struktur Proyek

lib/
├── navigation/
│ ├── home_page.dart
│ ├── schedule_page.dart
│ ├── profile_page.dart
│ └── main_screen.dart
│
├── penarikan_keuntungan/
│ └── penarikan_keuntungan_page.dart
│
├── assets/
│ ├── profile.jpg
│ └── kurir.jpg
│
├── main.dart
---

## Teknologi yang Digunakan

| Teknologi | Keterangan |
|------------|-------------|
| **Flutter** | Framework utama untuk membangun UI |
| **Dart** | Bahasa pemrograman utama aplikasi |
| **Material Design 3** | Desain antarmuka modern |
| **Navigator & Routing** | Navigasi antar halaman |
| **StatefulWidget & StatelessWidget** | Struktur arsitektur halaman |
| **Asset Images & Custom Colors** | Tampilan visual dan tema khas ReGreen |

---

## 🚀 Cara Menjalankan Proyek

###  Clone repository
```
git clone https://github.com/EdselSpth/ReGreen.git
cd ReGreen
flutter pub get
flutter run
