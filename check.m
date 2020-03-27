function [check_res, p_e] = check(noise_mes, g, mes, crc_mes)
    z = zeros(1, size(noise_mes, 2));
    check_res = 0;
    [q, s] = deconv(noise_mes, g);
    s = mod(s, 2);

    if isequal(s, z)
      if ~isequal(noise_mes(1:size(mes, 2)), mes)
          check_res = 1;
      end
    end
    p_e = sum(mod(noise_mes + crc_mes, 2)) / size(noise_mes, 2);
   
end