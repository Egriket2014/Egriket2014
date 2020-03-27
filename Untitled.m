clc
clear all
close all


m = 3;
k = 4;
g = [1 0 1 1];
snr_val = -30:5:-10;
N = 100000;

%Генерация кодовой книги
% alphabet = [0, 1];
% mes = randsrc(2^k, m, alphabet);
d = 0:(2 ^ m - 1);
nums = str2num(dec2bin(d));
mes = zeros(2 ^ m, m);
for i = 1:(2 ^ m)
    j = 0;
    rem = nums(i, 1);
    while rem > 0
        mes(i, size(mes, 2) - j) = mod(rem, 10);
        rem = fix(rem / 10);
        j = j + 1;
    end
end

%Добавление контрольной суммы
crc_mes = zeros(size(mes, 1), size(mes, 2) + size(g, 2) - 1);
crc_mes(1:size(mes, 1), 1:size(mes, 2)) = mes;
for i = 2:size(crc_mes, 1)
    [~, r] = deconv(crc_mes(i, 1:size(crc_mes, 2)), g);
    r = mod(r, 2);  
    crc_mes(i, (size(mes, 2) + 1):size(crc_mes, 2)) = r(size(mes, 2) + 1:size(crc_mes,2));
end
  
%Модуляция
mod_mes = crc_mes;
mod_mes = mod_mes * (-2) + 1;



p_e_mean_bit = zeros(1, length(snr_val));
errors_dec = zeros(1, length(snr_val));
i = 1;
for snr = snr_val
p_err = 0;
res = 0;

for j = 1:N
    %Шум
    rand_mes = round(rand * (size(mod_mes, 1) - 1)) + 1;
    noise_mes = noise(mod_mes(rand_mes, :), snr);
    
    %Демодуляция
    noise_mes = noise_mes < 0;
    
    %Проверка
    [result, p_e] = check(noise_mes, g, mes(rand_mes, :), crc_mes(rand_mes, :));
    
    p_err = p_err + p_e;
    res = res + result;
end
p_e_mean_bit(i) = p_err / N;
errors_dec(i) = res / N;
i = i + 1;
end


%Графики сигналов
nfig = 1;

	
figure(nfig);
nfig = nfig + 1;
q = erfc(sqrt(2 * 10 .^ (snr_val / 10)) ./ sqrt(2)) * 0.5;
semilogy(snr_val, p_e_mean_bit, snr_val, q, 'LineWidth', 2);
legend('Практика', 'Теория');
title('CRC-16');
xlabel('E_{b}/N_{0}');
ylabel('SNR');


[p_ed, p_ed_as, p_ed_super] = theor_ped(crc_mes, m, q);
figure(nfig);
nfig = nfig + 1;
% hold on
semilogy(snr_val, errors_dec, snr_val, p_ed_as, snr_val, p_ed);
legend('practical', 'asymp','theory')
% hold off

figure(nfig);
nfig = nfig + 1;
semilogy(snr_val, p_e_mean_bit,'LineWidth', 2);
legend('Практика');
title('CRC-16');
xlabel('E_{b}/N_{0}');
ylabel('SNR');
