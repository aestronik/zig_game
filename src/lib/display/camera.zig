const raylib  = @cImport({@cInclude("raylib.h");});
const State   = @import("../state.zig");
const CONFIG  = @import("../../config.zig");

pub const Entity = struct {
    Position:   raylib.Vector2,
    zoom:       f32,
};

pub fn update (state: *State.Entity) void {
    const camera = &state.Camera;

    if (raylib.IsKeyDown(74)) { camera.*.Position.x -= 1.0; }
    if (raylib.IsKeyDown(76)) { camera.*.Position.x += 1.0; }
    if (raylib.IsKeyDown(73)) { camera.*.zoom       -= 0.1; }
    if (raylib.IsKeyDown(75)) { camera.*.zoom       += 0.1; }

    if (camera.zoom < CONFIG.CAMERA_MIN_ZOOM) {camera.*.zoom = CONFIG.CAMERA_MIN_ZOOM; }
}