%  RESPONSI 1 PRAKTIKUM METODE NUMERIK
%  KASUS 1 : Galat - Error Pemotongan (Deret Maclaurin cos(x) dan e^x)
%  Rumus   : h = h0 * ( cos(t*v/lambda) + e^x )

clc; clear; close all;

%% 1. PARAMETER MASALAH
lambda = 12;            % panjang gelombang
v      = 36;            % kecepatan gelombang
x      = 10;            % nilai x pada suku e^x
h0     = 5;             % tinggi gelombang awal
N      = [23 24 25];    % batas iterasi deret (suku ke-0 sampai suku ke-n)
tol    = 1;             % batas toleransi galat relatif (dalam persen)

%% 2. DOMAIN WAKTU
t     = linspace(0, 5, 501);   % 501 titik, jarak antar titik 0.01
sudut = t * v / lambda;        % argumen cos, yaitu t*v/lambda (= 3t)

%% 3. SOLUSI EKSAK (fungsi bawaan MATLAB)
h_eksak = h0 * (cos(sudut) + exp(x));

%% 4. SOLUSI PENDEKATAN (deret Maclaurin) UNTUK SETIAP n
jml    = numel(N);
h_aprx = zeros(jml, numel(t));         % baris ke-i = hasil untuk n = N(i)
e_aprx = zeros(jml, 1);                % hampiran e^x untuk tiap n
for i = 1:jml
    n = N(i);
    % --- deret cos(a) = sum_{k=0}^{n} (-1)^k a^(2k)/(2k)!
    suku    = ones(size(sudut));       % suku ke-0 : a^0/0! = 1
    hsl_cos = suku;
    for k = 1:n
        suku    = -suku .* sudut.^2 ./ ((2*k-1) * (2*k));   % dari suku ke-(k-1)
        hsl_cos = hsl_cos + suku;
    end
    % --- deret e^x = sum_{k=0}^{n} x^k/k!
    suku_e  = 1;                       % suku ke-0 : x^0/0! = 1
    hsl_exp = 1;
    for k = 1:n
        suku_e  = suku_e * x / k;      % suku_k = suku_(k-1) * x / k
        hsl_exp = hsl_exp + suku_e;
    end
    e_aprx(i)   = hsl_exp;
    h_aprx(i,:) = h0 * (hsl_cos + hsl_exp);
end

%% 5. PERHITUNGAN GALAT TERHADAP SOLUSI EKSAK
galat_mutlak  = zeros(jml, numel(t));
galat_relatif = zeros(jml, numel(t));
for i = 1:jml
    galat_mutlak(i,:)  = abs(h_eksak - h_aprx(i,:));
    galat_relatif(i,:) = galat_mutlak(i,:) ./ abs(h_eksak) * 100;   % persen
end
rerata_mutlak  = mean(galat_mutlak, 2);    % rata-rata tiap baris (tiap n)
rerata_relatif = mean(galat_relatif, 2);

%% 6. TAMPILKAN HASIL DI COMMAND WINDOW
fprintf('=== HASIL KASUS 1 ===\n');
fprintf('lambda = %d, v = %d, x = %d, h0 = %d, 0 <= t <= 5\n\n', lambda, v, x, h0);
fprintf('e^x eksak (exp)   : %.6f\n', exp(x));
for i = 1:jml
    fprintf('e^x deret (n=%d) : %.6f  (galat = %.6f)\n', N(i), ...
        e_aprx(i), exp(x) - e_aprx(i));
end
fprintf('\n%-6s %-22s %-24s %-8s\n', 'n', 'Rerata galat mutlak', ...
    'Rerata galat relatif (%)', 'Status');
for i = 1:jml
    if rerata_relatif(i) < tol
        status = 'LAYAK';
    else
        status = 'TIDAK LAYAK';
    end
    fprintf('%-6d %-22.6f %-24.6f %-8s\n', N(i), rerata_mutlak(i), ...
        rerata_relatif(i), status);
end

%% 7. GRAFIK PERBANDINGAN EKSAK vs PENDEKATAN
figure('Name', 'Kasus 1 - Perbandingan h(t)');
plot(t, h_eksak,    'k-',  'LineWidth', 2.5); hold on;
plot(t, h_aprx(1,:), 'r--', 'LineWidth', 1.8);
plot(t, h_aprx(2,:), 'g-.', 'LineWidth', 1.8);
plot(t, h_aprx(3,:), 'b:',  'LineWidth', 2.2);
grid on; try, ytickformat('%.0f'); catch, end   % dilewati jika tidak tersedia
xlabel('t'); ylabel('h(t)');
title('Perbandingan h(t): Eksak vs Pendekatan Deret Maclaurin');
legend({'f_{eksak}', 'f_{n=23}', 'f_{n=24}', 'f_{n=25}'}, 'Location', 'best');
saveas(gcf, 'kasus1_grafik_h.png');

%% 8. GRAFIK GALAT MUTLAK
figure('Name', 'Kasus 1 - Galat Mutlak');
plot(t, galat_mutlak(1,:), 'r-',  'LineWidth', 1.8); hold on;
plot(t, galat_mutlak(2,:), 'g-',  'LineWidth', 1.8);
plot(t, galat_mutlak(3,:), 'b-',  'LineWidth', 1.8);
grid on;
xlabel('t'); ylabel('|h_{eksak} - h_{pendekatan}|');
title('Galat Mutlak terhadap Solusi Eksak');
legend({'n = 23', 'n = 24', 'n = 25'}, 'Location', 'best');
saveas(gcf, 'kasus1_grafik_galat.png');
