const std = @import("std");
const print = std.debug.print;
const raylib = @cImport({
    @cInclude("raylib.h");
});

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


const List = struct {
    /// Error handling
    const Error = error { Full };
    /// Enums
    const Size  = enum(usize) {
        Small  = 0x0100,
        Medium = 0x1000,
        Large  = 0x4000,
    };
    /// Types
    fn Entity    (comptime Generic_Entity: type) type {
        return struct {
            in_use: bool,
            data: Generic_Entity,
        };
    }
    fn Container (comptime Generic_Type:   type) type {
        return struct {
            Data: []List.Entity(Generic_Type),
            // Meta Data
            current_size: usize, // 0
            capacity:     usize, // N
            final_index:  usize, // 0
        };
    }
    /// Actions to be performed on Lists
    fn reset (container: anytype) void {
        var index: usize = 0;
        while (index < container.Data.len) {
            container.Data[index].in_use = false;
            container.Data[index].data.x = 25;
            index += 1;
        }
        container.current_size = 0;
        container.capacity     = container.Data.len;
        container.final_index  = 0;
    }
};

pub fn main() !void {
    var test_data: [0x100]List.Entity(raylib.Vector2) = undefined;
    var test_list = List.Container(raylib.Vector2) {
        .Data = &test_data,
        .current_size = 0,
        .capacity     = 100,
        .final_index  = 0,
    };
    List.reset(&test_list);

    const screen_width  = 800;
    const screen_height = 600;

    raylib.InitWindow(screen_width, screen_height, "zig_game");
    while (!raylib.WindowShouldClose()) {
        std.time.sleep(1000 / CONFIG.FPS * 1_000_000);
        raylib.BeginDrawing();
        raylib.ClearBackground(Palette.white);
        raylib.DrawFPS(100, 100);
        const x = raylib.GetMouseX();
        const y = raylib.GetMouseY();
        // const color = if (raylib.IsMouseButtonDown(0)) Palette.red else Palette.blue;
        const color = if (raylib.IsKeyDown(raylib.KEY_A)) Palette.red else Palette.blue;
        raylib.DrawLine(@intFromFloat(test_data[20].data.x), 0, x, y, color);
        raylib.EndDrawing();
    }
    raylib.CloseWindow();
}
