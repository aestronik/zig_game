const std     = @import("std");
const print   = std.debug.print;
const raylib  = @cImport({@cInclude("raylib.h");});
const List    = @import("lib/list.zig");
const Physics = @import("lib/physics.zig");
const State   = @import("lib/state.zig");

const CONFIG = struct {
    const FPS: u64 = 60;
};

const Palette = struct {
    const red = raylib.Color {
        .r = 255,
        .g = 0,
        .b = 0,
        .a = 255,
    };
    const blue = raylib.Color {
        .b = 255,
        .g = 0,
        .r = 0,
        .a = 255,
    };
    const green = raylib.Color {
        .g = 255,
        .r = 0,
        .b = 0,
        .a = 255,
    };
    const white = raylib.Color {
        .r = 255,
        .g = 255,
        .b = 255,
        .a = 255,
    };
};

pub fn main() !void {

    var state = State.Entity {
        .Physics_Container = List.initialize([Physics.size]List.Entity(Physics.Entity))
    };
    Physics.initialize(&state);

    const screen_width  = 800;
    const screen_height = 600;

    raylib.InitWindow(screen_width, screen_height, "zig_game");
    while (!raylib.WindowShouldClose()) {
        // print("test_list.Data.len = {} \n", .{test_list.Data.len});
        std.time.sleep(1000 / CONFIG.FPS * 1_000_000);
        raylib.BeginDrawing();
        raylib.ClearBackground(Palette.white);
        raylib.DrawFPS(100, 100);
        const x = raylib.GetMouseX();
        const y = raylib.GetMouseY();
        // const color = if (raylib.IsMouseButtonDown(0)) Palette.red else Palette.blue;
        const color = if (raylib.IsKeyDown(raylib.KEY_A)) Palette.red else Palette.blue;
        raylib.DrawLine(@intFromFloat(state.Physics_Container.Data[12].data.Position.x), 0, x, y, color);
        raylib.EndDrawing();
    }
    raylib.CloseWindow();
}
