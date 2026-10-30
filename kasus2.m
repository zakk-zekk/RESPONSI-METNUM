%  RESPONSI 1 PRAKTIKUM METODE NUMERIK
%  KASUS 2 : SPL - Harga Bahan Makanan per Kilogram
%  Metode  : Cek kelayakan metode iteratif -> Gauss-Seidel
%            (verifikasi dengan Gauss-Jordan dan operator backslash)

clc; clear; close all;

%% 1. DATA BELANJA (satuan asli)
nama  = {'Adel', 'Briza', 'Caca', 'Dinda'};
bahan = {'Beras', 'Telur', 'Tepung', 'Ayam'};
%                 Beras  Telur  Tepung  Ayam
jumlah = [ 2.5    1500     5      500;      % Adel   (kg, g, kg, g)
           40     0.75   1000       2;      % Briza  (hg, kg, g, kg)
           2000   15       50    6000;      % Caca   (g, hg, dag, g)
           1      4250     20       9 ];    % Dinda  (kg, g, hg, hg)
% faktor pengali satuan -> kg (1 hg = 0.1 kg, 1 dag = 0.01 kg, 1 g = 0.001 kg)
ke_kg  = [ 1      0.001    1     0.001;
           0.1    1        0.001 1;
           0.001  0.1      0.01  0.001;
           1      0.001    0.1   0.1 ];
total  = [161000; 149000; 251500; 173000];   % total belanja (Rp)

%% 2. KONVERSI SATUAN KE KILOGRAM DAN BENTUK SPL  A x = b
A = jumlah .* ke_kg;       % koefisien SPL (kg)
b = total;                 % ruas kanan (Rp)
n = length(b);

fprintf('=== 1. MATRIKS A (kg) DAN VEKTOR b (Rp) ===\n');
fprintf('%-8s %8s %8s %8s %8s | %12s\n', 'Nama', bahan{:}, 'Total');
for i = 1:n
    fprintf('%-8s %8.2f %8.2f %8.2f %8.2f | %12.0f\n', nama{i}, A(i,:), b(i));
end

%% 3. ANALISIS KELAYAKAN METODE ITERATIF (GAUSS-SEIDEL)
fprintf('\n=== 2. ANALISIS KONVERGENSI URUTAN ASLI ===\n');
yatidak = {'TIDAK', 'YA'};                 % dipilih dengan indeks (benar)+1
ketr    = {'TIDAK dominan', 'dominan'};
diag_a  = abs(diag(A));                    % |a_ii|
sisa    = sum(abs(A), 2) - diag_a;         % jumlah |a_ij| (j beda i) tiap baris
dom     = all(diag_a > sisa);              % dominan diagonal ketat?
for i = 1:n
    fprintf('Baris %d: |a_ii| = %.2f  vs  jumlah lainnya = %.2f -> %s\n', ...
        i, diag_a(i), sisa(i), ketr{(diag_a(i) > sisa(i)) + 1});
end
% jari-jari spektral matriks iterasi Gauss-Seidel T = -(D+L)^(-1) U
D = diag(diag(A));  Lm = tril(A, -1);  U = triu(A, 1);
T = -(D + Lm) \ U;
rho_asli = max(abs(eig(T)));
fprintf('Dominan diagonal ketat : %s\n', yatidak{dom + 1});
fprintf('Jari-jari spektral GS  : %.4f (konvergen jika < 1)\n', rho_asli);

% Uji coba nyata: Gauss-Seidel 8 iterasi pada urutan asli
x_uji = zeros(n, 1);
riw_asli = x_uji.';                        % baris pertama = tebakan awal
for iter = 1:8
    for i = 1:n
        idx = [1:i-1, i+1:n];              % semua indeks kecuali i
        x_uji(i) = (b(i) - A(i,idx) * x_uji(idx)) / A(i,i);
    end
    riw_asli(end+1, :) = x_uji.';
end
fprintf('\nUji Gauss-Seidel urutan asli (kolom: beras, telur, tepung, ayam):\n');
for k = 1:size(riw_asli,1)
    fprintf('iterasi %d : %16.2f %16.2f %16.2f %16.2f\n', k-1, riw_asli(k,:));
end

%% 4. PENUKARAN BARIS (PIVOT) AGAR DOMINAN DIAGONAL
% Baris i ditempatkan pada posisi j bila |a_ij| > jumlah elemen lain baris i
perm = zeros(1, n);
for i = 1:n
    for j = 1:n
        if abs(A(i,j)) > sum(abs(A(i,:))) - abs(A(i,j))
            perm(j) = i;
        end
    end
end
fprintf('\n=== 3. PENUKARAN BARIS ===\n');
if ~isequal(sort(perm), 1:n)
    error('Tidak ada penukaran baris yang membuat A dominan diagonal.');
end
fprintf('Urutan baris baru : %s\n', strjoin(nama(perm), ', '));
B = A(perm, :);
c = b(perm);
diag_b = abs(diag(B));
sisa2  = sum(abs(B), 2) - diag_b;
dom2   = all(diag_b > sisa2);
for i = 1:n
    fprintf('Baris %d (%s): |a_ii| = %.2f > %.2f\n', i, nama{perm(i)}, diag_b(i), sisa2(i));
end
D = diag(diag(B));  Lm = tril(B, -1);  U = triu(B, 1);
T = -(D + Lm) \ U;
rho_baru = max(abs(eig(T)));
fprintf('Dominan diagonal ketat : %s\n', yatidak{dom2 + 1});
fprintf('Jari-jari spektral GS  : %.4f\n', rho_baru);

%% 5. GAUSS-SEIDEL PADA SPL YANG SUDAH DITUKAR
tol     = 1e-6;
maxIter = 1000;
x   = zeros(n, 1);                         % tebakan awal x0 = 0
riw = x.';                                 % riwayat iterasi
for iter = 1:maxIter
    x_lama = x;
    for i = 1:n
        idx = [1:i-1, i+1:n];              % semua indeks kecuali i
        x(i) = (c(i) - B(i,idx) * x(idx)) / B(i,i);   % pakai nilai x terbaru
    end
    riw(end+1, :) = x.';
    if max(abs(x - x_lama)) < tol
        break;
    end
end
x_gs = x;
fprintf('\n=== 4. ITERASI GAUSS-SEIDEL (x0 = 0, toleransi %g) ===\n', tol);
fprintf('%-6s %12s %12s %12s %12s %12s\n', 'Iter', bahan{:}, 'Galat maks');
for k = 1:size(riw,1)
    if k == 1
        gal = NaN;
    else
        gal = max(abs(riw(k,:) - riw(k-1,:)));
    end
    fprintf('%-6d %12.4f %12.4f %12.4f %12.4f %12.6f\n', k-1, riw(k,:), gal);
end
fprintf('Konvergen pada iterasi ke-%d\n', iter);

%% 6. VERIFIKASI: GAUSS-JORDAN DAN BACKSLASH
M = [A, b];                                % matriks augmented SPL asli
for k = 1:n
    [~, p] = max(abs(M(k:n, k)));          % pivoting parsial
    p = p + k - 1;
    if p ~= k
        M([k p], :) = M([p k], :);
    end
    M(k, :) = M(k, :) / M(k, k);           % pivot menjadi 1
    for i = [1:k-1, k+1:n]                 % eliminasi di atas DAN di bawah
        M(i, :) = M(i, :) - M(i, k) * M(k, :);
    end
end
x_gj = M(:, end);
x_bs = A \ b;
fprintf('\n=== 5. HASIL AKHIR (Rp per kg) ===\n');
fprintf('%-8s %18s %18s %18s\n', 'Bahan', 'Gauss-Seidel', 'Gauss-Jordan', 'A\b');
for i = 1:n
    fprintf('%-8s %18.4f %18.4f %18.4f\n', bahan{i}, x_gs(i), x_gj(i), x_bs(i));
end
fprintf('\nResidu ||A*x - b|| (Gauss-Seidel) : %.6e\n', norm(A*x_gs - b));
fprintf('Selisih maksimum GS vs Gauss-Jordan : %.6e\n', max(abs(x_gs - x_gj)));
fprintf('\nKesimpulan harga per kilogram:\n');
for i = 1:n
    fprintf('  %-7s = Rp %8.0f / kg\n', bahan{i}, round(x_gs(i)));
end
