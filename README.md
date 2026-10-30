# Responsi 1 Praktikum Metode Numerik

Repositori ini berisi source code MATLAB untuk Responsi 1 mata kuliah Metode Numerik dengan materi **Galat, SPL (Sistem Persamaan Linear), dan SPNL (Sistem Persamaan Non-Linear)**.

| | |
|---|---|
| **Nama** | Febrian Zaki Hidayatulloh |
| **NIM** | L0325045 |
| **Program Studi** | Informatika |
| **Fakultas** | Teknologi Informasi dan Sains Data |
| **Universitas** | Universitas Sebelas Maret |

## Struktur Repositori

```
.
├── kasus1.m    # Galat dan error pemotongan (deret Maclaurin)
├── kasus2.m    # SPL: Gauss-Seidel, Gauss-Jordan, dan A\b
├── kasus3.m    # Persamaan non-linier: metode grafik dan biseksi
└── README.md
```

Setiap kasus ditulis dalam **satu file script** tanpa function terpisah, sehingga cukup dijalankan langsung.

## Ringkasan Kasus

### Kasus 1 – Galat dan Error Pemotongan

Menghitung tinggi gelombang air laut

```
h = h0 * (cos(t*v/lambda) + e^x)
```

dengan λ = 12, v = 36, x = 10, h0 = 5, dan 0 ≤ t ≤ 5. Fungsi `cos` dan `e^x` dihampiri dengan deret Maclaurin yang dipotong pada suku ke-n (n = 23, 24, 25), lalu dibandingkan dengan solusi eksak dari fungsi bawaan.

- Setiap suku deret dihitung secara rekursif dari suku sebelumnya, sehingga tidak perlu menghitung pangkat dan faktorial yang besar.
- Keluaran: grafik perbandingan keempat fungsi, grafik galat mutlak, serta tabel rerata galat mutlak dan relatif.

| n | Rerata galat mutlak | Rerata galat relatif | Toleransi 1% |
|---|---|---|---|
| 23 | 13,229335 | 0,012012 % | Layak |
| 24 | 5,170645 | 0,004695 % | Layak |
| 25 | 1,947170 | 0,001768 % | Layak |

### Kasus 2 – SPL (Metode Langsung dan Tidak Langsung)

Mencari harga beras, telur, tepung, dan ayam per kilogram dari total belanja empat orang dengan satuan berbeda-beda (kg, hg, dag, g).

1. Semua satuan dikonversi ke kilogram sehingga terbentuk SPL `A x = b` berukuran 4×4.
2. Kelayakan Gauss-Seidel diperiksa lewat dominansi diagonal dan jari-jari spektral matriks iterasi.
3. Pada urutan persamaan asli matriks tidak dominan diagonal (ρ = 21,43), sehingga Gauss-Seidel divergen dan jawaban utama diperoleh dengan **Gauss-Jordan**.
4. Sebagai pembanding, baris ditukar menjadi urutan Briza, Dinda, Adel, Caca sehingga matriks dominan diagonal (ρ = 0,206) dan Gauss-Seidel konvergen dalam 18 iterasi.
5. Hasil dibandingkan dengan operator `A \ b` dan diperiksa dengan substitusi balik.

| Bahan | Harga per kg |
|---|---|
| Beras | Rp14.000 |
| Telur | Rp24.000 |
| Tepung | Rp15.000 |
| Ayam | Rp30.000 |

### Kasus 3 – Persamaan Non-Linier

Mencari jari-jari bola dan tabung (tinggi tabung t = 2r) bila volume bola 300 cm³. Dari perbandingan volume diperoleh volume tabung 450 cm³ dan volume tabung di luar bola 150 cm³, sehingga persamaan yang diselesaikan adalah

```
f(r) = (2/3) * pi * r^3 - 150 = 0
```

- Metode grafik menunjukkan akar berada pada selang awal [4, 5].
- Metode biseksi dengan toleransi 10⁻⁶ berhenti pada iterasi ke-20.
- Hasil: r ≈ 4,152831 cm, tinggi tabung ≈ 8,305662 cm, dan volume tabung di luar bola ≈ 150 cm³. Hasil ini sesuai dengan solusi analitik (225/π)^(1/3).

## Cara Menjalankan

Script dirancang agar dapat dijalankan di **MATLAB** maupun **GNU Octave**.

1. Clone repositori ini.
   ```bash
   git clone https://github.com/zakk-zekk/RESPONSI-METNUM.git
   ```
2. Buka MATLAB atau Octave, lalu jadikan folder repositori ini sebagai *Current Directory*.
3. Jalankan script dengan mengetik nama filenya di Command Window.
   ```matlab
   kasus1
   kasus2
   kasus3
   ```

Setiap script mencetak hasil di Command Window. Script `kasus1.m` dan `kasus3.m` juga menyimpan grafik sebagai file `.png` di folder tempat script dijalankan.

**Catatan:** pada Octave, sumbu-y grafik Kasus 1 mungkin tampil dalam notasi ilmiah karena perintah `ytickformat` dilewati secara otomatis.
