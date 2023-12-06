const raylib  = @cImport({@cInclude("raylib.h");});

pub const red = raylib.Color {
    .r = 255,
    .g = 0,
    .b = 0,
    .a = 255,
};
pub const blue = raylib.Color {
    .b = 255,
    .g = 0,
    .r = 0,
    .a = 255,
};
pub const green = raylib.Color {
    .g = 255,
    .r = 0,
    .b = 0,
    .a = 255,
};
pub const white = raylib.Color {
    .r = 255,
    .g = 255,
    .b = 255,
    .a = 255,
};