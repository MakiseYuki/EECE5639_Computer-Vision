x_map = abs(c_map);

c = find(c_map<5);

true_map = zeros(375,450);


true_map(c) = v_map(c);
V = mat2gray(true_map);