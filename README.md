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

## Cara Menjalankan Proyek

###  Jalankan Mobile | Untuk saat ini hanya dapat berjalan fungsionalitas 
```
git clone https://github.com/EdselSpth/ReGreen.git
cd ReGreen
flutter pub get
flutter run
```

### Jalankan Backend dan WEB Admin
```
Nyalakan mysql dan apache di xampp/laragon
Buka admin mysql
Buat database ReGree
git clone https://github.com/EdselSpth/ReGreen_Website.git
cd ReGreen_Website
cd Backend
npm install
npm start
cd ..
cd frontend
composer install
php artisan serve
```

## API Documentation

Aplikasi ini menggunakan arsitektur Hybrid:
1.  **REST API (Node.js)**: Untuk manajemen konten (Artikel, Video) dan Keuntungan.
2.  **Firebase (Firestore)**: Untuk data user, area, dan jadwal penjemputan.

**Base URL (Android Emulator):** `http://10.0.2.2:3000/api`

---

## 🚀 1. REST API Endpoints

### 📰 Modul Artikel
Prefix: `/artikel`

| Method | Endpoint | Deskripsi | Body / Parameter (JSON) |
| :--- | :--- | :--- | :--- |
| `GET` | `/` | Mengambil semua artikel | - |
| `GET` | `/:id` | Mengambil detail artikel berdasarkan ID | `id` (URL Parameter) |
| `POST` | `/` | Membuat artikel baru | `{ "nama_artikel": "String", "file_pdf": "String (Link/Path)" }` |
| `PUT` | `/:id` | Mengupdate artikel | `{ "nama_artikel": "String", "file_pdf": "String" }` |
| `DELETE` | `/:id` | Menghapus artikel | `id` (URL Parameter) |

### 🎬 Modul Video
Prefix: `/video`

| Method | Endpoint | Deskripsi | Body / Parameter (JSON) |
| :--- | :--- | :--- | :--- |
| `GET` | `/` | Mengambil semua video | - |
| `GET` | `/:id` | Mengambil detail video | `id` (URL Parameter) |
| `POST` | `/` | Menambah video baru | `{ "nama_video": "String", "link_youtube": "String", "deskripsi": "String" }` |
| `PUT` | `/:id` | Update data video | `{ "nama_video": "String", "link_youtube": "String", "deskripsi": "String" }` |
| `DELETE` | `/:id` | Menghapus video | `id` (URL Parameter) |

### 💰 Modul Keuntungan (Finance)
Prefix: `/keuntungan`

| Method | Endpoint | Deskripsi | Body / Query Parameters |
| :--- | :--- | :--- | :--- |
| `POST` | `/` | Mengajukan penarikan dana | **Body (JSON):**<br>`{`<br>  `"firebase_uid": "String",`<br>  `"nama_pengguna": "String",`<br>  `"nominal": int,`<br>  `"rekening": "String",`<br>  `"metode": "String"`<br>`}` |
| `GET` | `/user/:firebaseUid` | Mengambil riwayat status penarikan user | **URL Param:** `firebaseUid`<br>**Query Params:**<br>`?page=1` (Default: 1)<br>`?limit=10` (Default: 10) |

---

## 🔥 2. Firebase Firestore Schema

### 👤 Collection: `users`
Menyimpan data profil pengguna dan status verifikasi area.

| Field | Tipe Data | Deskripsi |
| :--- | :--- | :--- |
| `uid` | String | Document ID (Sama dengan Authentication UID) |
| `email` | String | Email pengguna |
| `username` | String | Nama tampilan pengguna |
| `address` | Map | Objek alamat lengkap |
| `areaId` | String | ID referensi ke collection `areas` |
| `areaStatus` | String | Status area (contoh: `'approved'`, `'pending'`) |
| `createdAt` | Timestamp | Waktu pembuatan akun |

### 🚚 Collection: `penjemputan`
Menyimpan jadwal penjemputan sampah.

| Field | Tipe Data | Deskripsi |
| :--- | :--- | :--- |
| `areaId` | String | ID wilayah layanan |
| `userId` | String | ID pengguna yang memesan penjemputan |
| `alamat` | Map | Detail alamat penjemputan |
| `courier_name` | String | Nama kurir (Default: `'Ajang'`) |
| `date` | String | Tanggal penjemputan (`YYYY-MM-DD`) |
| `time` | String | Waktu slot (contoh: `'15:00-17:00'`) |
| `status` | String | Status jadwal (`'tersedia'`, `'menunggu'`, `'selesai'`) |
| `waste_type` | String | Jenis sampah (contoh: `'campuran'`) |
| `createdAt` | Timestamp | Waktu jadwal dibuat |

### 📍 Collection: `areas`
Menyimpan data cakupan wilayah layanan.

| Field | Tipe Data | Deskripsi |
| :--- | :--- | :--- |
| `nama_area` | String | Nama wilayah/kecamatan |
| `kota` | String | Kota wilayah |
| `kodepos` | String | Kode pos wilayah |
| `createdAt` | Timestamp | Waktu area ditambahkan |

