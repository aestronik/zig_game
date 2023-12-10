const raylib  = @cImport({@cInclude("raylib.h");});

pub fn direction (source: raylib.Vector2, destination: raylib.Vector2) raylib.Vector2 {
    const x = destination.x - source.x;
    const y = destination.y - source.y;
    return raylib.Vector2 {.x = x, .y = y};
}
pub fn distance (vector_1: raylib.Vector2, vector_2: raylib.Vector2) f32 {
    const x = vector_1.x - vector_2.x;
    const y = vector_1.y - vector_2.y;
    return @sqrt( x * x + y * y);
}
pub fn magnitude (vector: raylib.Vector2) f32 {
    const x = vector.x;
    const y = vector.y;
    return @sqrt( x * x + y * y);
}
pub fn normalize (vector: raylib.Vector2) raylib.Vector2 {
    const scale = magnitude(vector);
    if (scale == 0) {
        return raylib.Vector2 {
            .x = 0,
            .y = 0
        };
    }
    // At least I think that's how this works.
    return raylib.Vector2 {
        .x = vector.x / scale,
        .y = vector.y / scale
    };
}