function [p_ed, p_ed_as, p_ed_super] = theor_ped(c_mes_control, m, q)

d_h = 10000;
for i = 2:size(c_mes_control, 1)
    d = sum(c_mes_control(i, 1:size(c_mes_control, 2)));
    if d < d_h
       d_h = d;
    end
end

A_i = zeros(1, size(c_mes_control, 2) - d_h + 1);
for i = 2:size(c_mes_control, 1)
    d = sum(c_mes_control(i, 1:size(c_mes_control, 2))) - d_h + 1;
    A_i(d) = A_i(d) + 1;
end

p_ed = 0;
j = 0;
n = size(c_mes_control, 2);
for i = A_i
    p_ed = p_ed + i * q .^ (j + d_h) .* (1 - q) .^ (n - j - d_h);
    j = j + 1;
end

p_ed_super = (2 ^ m - 1) * q .^ d_h;
p_ed_as = repmat([0.5 ^ (size(c_mes_control, 2) - m)], 1, ...
size(p_ed_super, 2));
end