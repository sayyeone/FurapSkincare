# FurapSkin - Premium E-Commerce Skin Care

FurapSkin adalah sebuah aplikasi E-Commerce modern berbasis web untuk penjualan produk perawatan kulit (Skin Care). Aplikasi ini dirancang dengan antarmuka pengguna (UI) yang premium dan responsif, serta memisahkan alur kerja antara Pelanggan (Customer) dan Administrator (Admin).

---

## 💻 Teknologi yang Digunakan

Aplikasi ini dikembangkan menggunakan teknologi Java Enterprise Edition (Java EE) dengan pendekatan arsitektur **Model-View-Controller (MVC)** yang solid.

- **Bahasa Pemrograman**: Java 17
- **Arsitektur**: Servlets & JSP (JavaServer Pages)
- **Database**: MySQL 8.0
- **Web Server**: Apache Tomcat 10.1
- **Build Tool**: Apache Maven
- **Containerization**: Docker & Docker Compose
- **Styling (Frontend)**: Vanilla CSS dengan modern UI/UX design (Glassmorphism, Flexbox/Grid)
- **Library Tambahan**: `jBCrypt` (untuk enkripsi *password* pengguna)

---

## 🚀 Cara Menjalankan Aplikasi

Aplikasi ini sangat mudah dijalankan karena sudah dikemas menggunakan **Docker**. Anda tidak perlu melakukan konfigurasi database maupun instalasi server secara manual.

**Langkah-langkah:**
1. Pastikan **Docker Desktop** sudah terinstal dan berjalan di komputer/laptop Anda.
2. Buka Terminal (atau Command Prompt) dan arahkan ke folder proyek ini (`furap-v2`).
3. Jalankan perintah sakti berikut:
   ```bash
   docker-compose up --build -d
   ```
4. Tunggu beberapa saat hingga proses kompilasi selesai (sekitar 1-2 menit pada proses awal).
5. Akses aplikasi melalui *browser* Anda:
   - **Halaman Web Utama**: `http://localhost:8080`
   - **Manajemen Database (opsional)**: `http://localhost:8081`

> **Penting**: Sistem database dan data awal (kategori, dll) akan terisi secara otomatis tanpa perlu *import* file SQL.

---

## 📖 Cara Penggunaan FurapSkin

FurapSkin memiliki dua sisi penggunaan utama: **Sisi Pelanggan (Customer)** dan **Sisi Administrator (Admin)**.

### 1. Kredensial Akses (PENTING)
Untuk keperluan pengujian (Tugas Besar), gunakan panduan berikut untuk membuat dan mengakses akun:

**Cara Membuat Akun Administrator (Admin):**
- Buka halaman **Sign Up** (Register).
- Isi data diri Anda seperti biasa (Email, Password, dll).
- Pada kolom isian rahasia **Admin Token** (atau Kredensial Admin), masukkan kode wajib ini: **`PBO2026`**
- Selesai! Akun Anda akan otomatis terdaftar dengan hak akses penuh sebagai Admin.

**Akun Pelanggan (Customer):**
- Anda dapat mendaftar (Register) akun baru seperti biasa dari halaman Sign Up.
- Kosongkan bagian Admin Token, maka akun tersebut otomatis menjadi Customer biasa.

### 2. Alur Penggunaan (User Flow)

**A. Alur Pelanggan (Customer):**
1. **Register & Login**: Masuk ke dalam aplikasi.
2. **Katalog Produk**: Lihat berbagai produk kecantikan yang tersedia (kategori Skincare, Bodycare, Haircare, dll).
3. **Keranjang (Cart)**: Tambahkan produk ke keranjang belanja.
4. **Checkout**: Konfirmasi pesanan, masukkan alamat tujuan, dan pilih metode pembayaran (Bank Transfer / E-Wallet).
5. **Dashboard Customer**: Setelah dibayar, pesanan Anda akan masuk ke status **PAID**. Tunggu hingga admin mengirimkan barang.
6. **Konfirmasi Penerimaan & Review**: Saat pesanan dikirim (status berubah menjadi **SHIPPED**), klik tombol "Pesanan Diterima". Setelah pesanan selesai (**COMPLETED**), Anda bisa memberikan **Bintang & Ulasan (Review)** secara terpisah untuk setiap item produk.

**B. Alur Administrator (Admin):**
1. **Login sebagai Admin**: Masuk menggunakan kredensial Admin. Anda akan otomatis diarahkan ke **Admin Dashboard**.
2. **Dashboard (Action Center)**:
   - **Pending Approvals**: Setujui pembayaran baru yang masuk dari pelanggan.
   - **Ready to Ship**: Temukan pesanan yang sudah dibayar (PAID) dan klik tombol **Ship Order** untuk mengirimkan barang ke kurir (mengubah status menjadi SHIPPED dan sistem akan memunculkan nomor resi otomatis).
3. **Sales Report**: Laporan riwayat penjualan yang menampilkan status semua transaksi, akses *invoice*, serta analisis performa produk secara *real-time* (**Top Rated Products** vs **Needs Improvement**).
4. **Product Management**: Katalog khusus Admin untuk Menambah (Add), Mengedit (Edit), dan Menghapus (Delete) produk beserta unggahan gambar aslinya.

---
*Dikembangkan untuk memenuhi Tugas Besar PBO.*
