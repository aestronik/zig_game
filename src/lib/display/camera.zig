const raylib  = @cImport({@cInclude("raylib.h");});
const State   = @import("../state.zig");
const CONFIG  = @import("../../config.zig");

pub const Entity = struct {
    Position:   raylib.Vector2,
    Target:     raylib.Vector2,
    zoom:       f32,
};

pub fn initialize () Entity {
    return Entity { 
            .Position   = raylib.Vector2 { .x = 0, .y = 0 }, 
            .Target     = raylib.Vector2 { .x = 0, .y = 0 }, 
            .zoom       = CONFIG.DISPLAY_MAGNIFICATION 
    };
}

pub fn update (state: *State.Entity) void {
    const camera = &state.Camera;

    if (raylib.IsKeyDown(74)) { camera.*.Position.x -= 1.0; }
    if (raylib.IsKeyDown(76)) { camera.*.Position.x += 1.0; }
    if (raylib.IsKeyDown(73)) { camera.*.zoom       -= 0.1; }
    if (raylib.IsKeyDown(75)) { camera.*.zoom       += 0.1; }

    if (camera.zoom < CONFIG.CAMERA_MIN_ZOOM) {camera.*.zoom = CONFIG.CAMERA_MIN_ZOOM; }
}

pub fn offset_x ( camera: Entity, target: f32 ) f32 {
    return (
        target
        - camera.Position.x                             // Offset objects by camera position
        + CONFIG.DISPLAY_WIDTH / 2                      // Center the objects on the camera
        * CONFIG.DISPLAY_MAGNIFICATION / camera.zoom    // offset the centering based on the zoom vs window 
    ) * camera.zoom;
}
pub fn offset_y ( camera: Entity, target: f32 ) f32 {
    return (
        target
        - camera.Position.y                             // Offset objects by camera position
        + CONFIG.DISPLAY_HEIGHT / 2                      // Center the objects on the camera
        * CONFIG.DISPLAY_MAGNIFICATION / camera.zoom    // offset the centering based on the zoom vs window 
    ) * camera.zoom;
}