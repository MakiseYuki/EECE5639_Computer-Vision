function m = grayVisual(map)

top = max(max(map));
button = min(min(map));
scale = 255/(top-button);
m = map.*scale;