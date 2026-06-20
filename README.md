# FurapSkin - E-Commerce Web Application

Aplikasi E-Commerce Skin Care berbasis Java EE (JSP/Servlet) dengan arsitektur MVC.

## Persyaratan Sistem
Aplikasi ini dapat dijalankan dengan dua cara:
1. **Menggunakan Docker (Sangat Direkomendasikan)** - *Plug and play, tanpa perlu konfigurasi server manual.*
2. **Tanpa Docker (Manual)** - Menggunakan XAMPP/WAMP dan Apache Tomcat secara lokal.

---

### Opsi 1: Menjalankan dengan Docker (Rekomendasi)

Ini adalah cara paling mudah karena Docker akan otomatis mengonfigurasi Java, Tomcat, MySQL, dan phpMyAdmin.

**Langkah-langkah:**
1. Pastikan **Docker Desktop** sudah terinstal dan berjalan di laptop Anda.
2. Buka Terminal / Command Prompt dan arahkan ke folder proyek ini (`furap-v2`).
3. Jalankan perintah berikut:
   ```bash
   docker-compose up --build -d
   ```
4. Tunggu beberapa saat hingga proses kompilasi selesai.
5. Akses aplikasi melalui *browser*:
   - **Aplikasi Web**: `http://localhost:8080`
   - **Database (phpMyAdmin)**: `http://localhost:8081`

---

### Opsi 2: Menjalankan Tanpa Docker (Setup Manual IDE & XAMPP)

Jika dosen ingin menjalankan secara tradisional melalui IDE (IntelliJ IDEA / Eclipse) dan XAMPP:

**1. Persiapan Database (XAMPP):**
1. Buka XAMPP dan jalankan **MySQL**.
2. Buka `http://localhost/phpmyadmin`.
3. Buat database baru bernama `furapskin_v2`.
4. Import file SQL yang berada di folder `db/init/schema.sql` ke dalam database tersebut.
5. Masukkan data kategori standar ke tabel `categories` (misal: Skincare, Bodycare, Haircare, Accessories) karena tabel ini berelasi dengan tabel `products`.

**2. Konfigurasi Koneksi Database di Java:**
1. Buka file `src/main/java/com/furapskin/dao/DatabaseConnection.java`.
2. Ubah URL koneksi dari konfigurasi Docker menjadi konfigurasi *localhost* lokal Anda.
   Ubah baris ini:
   ```java
   private static final String URL = "jdbc:mysql://furapskin-db:3306/furapskin_v2";
   private static final String USER = "root";
   private static final String PASS = "root";
   ```
   Menjadi konfigurasi bawaan XAMPP:
   ```java
   private static final String URL = "jdbc:mysql://localhost:3306/furapskin_v2";
   private static final String USER = "root";
   private static final String PASS = ""; // Kosongkan jika password root XAMPP Anda kosong
   ```

**3. Mengatur Akun Admin (Seeder):**
Secara *default*, semua akun yang baru didaftarkan lewat halaman `Register` akan berstatus sebagai `CUSTOMER`.
Untuk menguji fitur Dasbor Admin, ikuti langkah ini:
1. Jalankan aplikasi dan daftar sebuah akun baru seperti biasa lewat halaman *Sign Up*.
2. Buka *database* (`http://localhost:8081` jika pakai Docker, atau `http://localhost/phpmyadmin` jika XAMPP).
3. Buka tabel `users`.
4. Ubah nilai pada kolom `role` untuk akun Anda dari `CUSTOMER` menjadi `ADMIN`.
5. Login kembali ke dalam aplikasi, dan Anda akan otomatis diarahkan ke **Admin Dashboard**!

**4. Deploy ke Tomcat Lokal:**
1. Pastikan Anda menggunakan **Apache Tomcat versi 10** (karena aplikasi ini menggunakan `jakarta.servlet` bukan `javax.servlet`).
2. Pasang proyek ini ke Tomcat menggunakan IDE Anda (Eclipse/IntelliJ).
3. Jalankan server Tomcat.
4. Akses aplikasi di `http://localhost:8080`.

---
*Dibuat untuk Tugas Besar PBO.*
