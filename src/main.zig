const std     = @import("std");
const print   = std.debug.print;
const raylib  = @cImport({@cInclude("raylib.h");});
const List    = @import("lib/list.zig");
const Physics = @import("lib/physics.zig");
const State   = @import("lib/state.zig");
const CONFIG  = @import("config.zig");
const Scene   = @import("lib/scene/main.zig");
const Palette = @import("lib/palette.zig");
pub fn main() !void {
    // Get raylib working
    raylib.InitWindow(
        CONFIG.DISPLAY_WIDTH,
        CONFIG.DISPLAY_HEIGHT,
        CONFIG.GAME_NAME
    );
    defer { raylib.CloseWindow(); }
    // Fire up the game state
    var game_state = State.Entity {
        .Physics_Container = List.initialize([CONFIG.PHYSICS_MAX]List.Entity(Physics.Entity)),
        .Scene_Container   = List.initialize([CONFIG.SCENES_MAX]List.Entity(Scene.Name)),
        .RNG               = std.rand.DefaultPrng.init(42),
        .texture           = raylib.LoadTexture("assets/visual/missing_texture_32_hollow.png")
    };
    // Initialize everything
    _ = try Scene.enter(Scene.Name.Default, &game_state);
    // Now start the game loop
    while (!raylib.WindowShouldClose()) {
        _ = try Scene.update(Scene.Name.Default, &game_state);
        _ = try Scene.render(Scene.Name.Default, &game_state);
    }
}


test {
    _ = @import("lib/list.zig");
}