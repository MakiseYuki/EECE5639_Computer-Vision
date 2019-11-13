%function dense_component(map)

map = MAP2;
windowsR = 1;

window = zeros(windowsR*2+1,windowsR*2+1);
MAP = zeros(size(map));
[x,y] = size(true_map);

for i = windowsR+1:x-windowsR
    for j = windowsR+1:y-windowsR
        window = map(i-windowsR:i+windowsR,j-windowsR:j+windowsR);
        m = mean(window);
        if abs(map(i,j))-m > 2
            MAP(i,j) = NaN;
        else
            MAP(i,j) = map(i,j);
        end
    end
end

