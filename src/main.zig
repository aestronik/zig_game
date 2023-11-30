const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

pub fn main() !void {
    const screen_width = 800;
    const screen_height = 450;

    ray.InitWindow(screen_width, screen_height, "zig_game");
    while (!ray.WindowShouldClose()) {
        ray.BeginDrawing();
        ray.EndDrawing();
    }
    ray.CloseWindow();
}
