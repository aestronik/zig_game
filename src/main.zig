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

const State = struct {
    Physics_Container: List.Container([Physics.size]List.Entity(Physics.Entity))
};

const Physics = struct {
    /// Array size
    const size   = 0x4000;
    /// Associated type
    const Entity = struct {
        Position: raylib.Vector2,
        Velocity: raylib.Vector2,
        size:     f64
    };
    /// Setting up the state properly
    fn initialize (state: *State) void {
        List.reset(&state.Physics_Container);
    }
};
const List = struct {
    /// Error handling
    const Error = error { Full };
    /// Types
    fn Entity    (comptime Generic_Entity: type) type {
        return struct {
            in_use: bool,
            data: Generic_Entity,
        };
    }
    fn Container (comptime Generic_Array:  type) type {
        return struct {
            Data:         Generic_Array,
            // Meta Data
            current_size: usize, // 0
            capacity:     usize, // N
            final_index:  usize, // 0
        };
    }
    /// Actions to be performed on Lists
    fn initialize (comptime Generic_Array: type) List.Container(Generic_Array) {
        return List.Container(Generic_Array) {
            .Data         = undefined,
            .current_size = 0,
            .capacity     = 0,
            .final_index  = 0,
        };
    }
    fn reset (container: anytype) void {
        var index: usize = 0;
        while (index < container.Data.len) {
            container.Data[index].in_use = false;
            index += 1;
        }
        container.current_size = 0;
        container.capacity     = container.Data.len;
        container.final_index  = 0;
    }
};

pub fn main() !void {

    var new_state = State {
        .Physics_Container = List.initialize([Physics.size]List.Entity(Physics.Entity))
    };

    Physics.initialize(&new_state);


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
        raylib.DrawLine(@intFromFloat(new_state.Physics_Container.Data[12].data.Position.x), 0, x, y, color);
        raylib.EndDrawing();
    }
    raylib.CloseWindow();
}
