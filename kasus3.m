%  RESPONSI 1 PRAKTIKUM METODE NUMERIK
%  KASUS 3 : Persamaan Non-Linier - Jari-jari Bola dalam Tabung
%  Metode  : Grafik (menentukan selang awal) + Biseksi

clc; clear; close all;

%% 1. PERUMUSAN PERSAMAAN NON-LINIER
V_bola = 300;                     % volume bola (cm^3)
% Tabung membungkus bola  -> tinggi t = 2r
%   V_bola   = (4/3)*pi*r^3
%   V_tabung = pi*r^2*t = 2*pi*r^3
%   V_bola : V_tabung = (4/3) : 2 = 2 : 3
V_tabung = (3/2) * V_bola;        % = 450 cm^3
V_luar   = V_tabung - V_bola;     % = 150 cm^3 (volume tabung di luar bola)
% V_luar = (2/3)*pi*r^3  ->  f(r) = (2/3)*pi*r^3 - V_luar = 0
f = @(r) (2/3) * pi * r.^3 - V_luar;

fprintf('=== 1. PERUMUSAN ===\n');
fprintf('V_bola   = %.2f cm^3\n', V_bola);
fprintf('V_tabung = %.2f cm^3 (= 3/2 x V_bola)\n', V_tabung);
fprintf('V_luar   = %.2f cm^3\n', V_luar);
fprintf('Persamaan: f(r) = (2/3)*pi*r^3 - %.0f = 0\n', V_luar);

%% 2. METODE GRAFIK UNTUK MENENTUKAN SELANG AWAL
r = 0:0.01:8;
figure('Name', 'Kasus 3 - Metode Grafik');
plot(r, f(r), 'b-', 'LineWidth', 2); hold on;
plot([0 8], [0 0], 'k-');                        % sumbu f(r) = 0
grid on; xlabel('r (cm)'); ylabel('f(r)');
title('Metode Grafik: f(r) = (2/3)\pi r^3 - 150');
a0 = 4;  b0 = 5;                                 % selang dari pengamatan grafik
plot([a0 b0], [f(a0) f(b0)], 'ro', 'MarkerFaceColor', 'r');
legend({'f(r)', 'f(r) = 0', 'Titik awal a=4, b=5'}, 'Location', 'northwest');
saveas(gcf, 'kasus3_grafik.png');

fprintf('\n=== 2. METODE GRAFIK ===\n');
fprintf('f(%d) = %10.6f\n', a0, f(a0));
fprintf('f(%d) = %10.6f\n', b0, f(b0));
fprintf('f(a)*f(b) = %.4f < 0  -> terdapat akar pada [%d, %d]\n', f(a0)*f(b0), a0, b0);

%% 3. METODE BISEKSI
tol     = 1e-6;                  % toleransi (setengah lebar selang)
maxIter = 100;
a = a0;  b = b0;
if f(a) * f(b) > 0
    error('f(a) dan f(b) bertanda sama: tidak ada jaminan akar di [a,b].');
end
tabel = zeros(maxIter, 8);       % kolom: i a b c f(a) f(b) f(c) galat
for i = 1:maxIter
    c     = (a + b) / 2;                       % titik tengah
    galat = (b - a) / 2;                       % batas galat pada iterasi ini
    tabel(i,:) = [i, a, b, c, f(a), f(b), f(c), galat];
    if f(a) * f(c) < 0
        b = c;                                 % akar di [a, c]
    else
        a = c;                                 % akar di [c, b]
    end
    if galat < tol || f(c) == 0
        break;
    end
end
tabel  = tabel(1:i, :);                        % buang baris yang tidak terpakai
r_akar = c;

fprintf('\n=== 3. TABEL ITERASI BISEKSI ===\n');
fprintf('%-3s %10s %10s %11s %11s %11s %11s %12s\n', 'i', 'a', 'b', 'c', ...
    'f(a)', 'f(b)', 'f(c)', 'Galat');
for k = 1:size(tabel,1)
    fprintf('%-3d %10.6f %10.6f %11.7f %11.6f %11.6f %11.6f %12.8f\n', tabel(k,:));
end

%% 4. HASIL AKHIR DAN VERIFIKASI
r_eksak = (V_luar * 3 / (2 * pi))^(1/3);        % solusi analitik pembanding
fprintf('\n=== 4. HASIL AKHIR ===\n');
fprintf('Jari-jari bola = jari-jari tabung r = %.6f cm\n', r_akar);
fprintf('Tinggi tabung  t = 2r               = %.6f cm\n', 2*r_akar);
fprintf('Volume bola    (4/3)*pi*r^3         = %.4f cm^3\n', 4/3*pi*r_akar^3);
fprintf('Volume tabung  2*pi*r^3             = %.4f cm^3\n', 2*pi*r_akar^3);
fprintf('Volume tabung di luar bola          = %.4f cm^3\n', 2/3*pi*r_akar^3);
fprintf('f(r_akar)                           = %.6e\n', f(r_akar));
fprintf('Solusi analitik r = (225/pi)^(1/3)  = %.6f cm\n', r_eksak);
fprintf('Selisih |r_biseksi - r_analitik|    = %.6e\n', abs(r_akar - r_eksak));
