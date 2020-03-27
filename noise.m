function [mes] = noise(mes, snr)
    l = size(mes, 2);
    snr_lin = 10 ^ (snr / 10);
    energy = sum(mes .^ 2) / l;
    n0 = energy / (snr_lin * 2);
    noiseSigma = sqrt(n0);
    n = noiseSigma * randn(1,l);

    mes = mes + n;
end