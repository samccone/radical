exports.rgbToHex = function(rgb) {
  return rgbToHex(JSON.parse(rgb)[0], JSON.parse(rgb)[1], JSON.parse(rgb)[2]);
}


function componentToHex(c) {
    var hex = c.toString(16);
    return hex.length == 1 ? "0" + hex : hex;
}

function rgbToHex(r, g, b) {
    return "#" + componentToHex(r) + componentToHex(g) + componentToHex(b);
}
