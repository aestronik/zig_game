const std     = @import("std");
const print   = std.debug.print;

const Scene   = @import("main.zig");
const State   = Scene.State;
const Code    = Scene.Code;

const List    = @import("../list.zig");

const raylib  = @cImport({@cInclude("raylib.h");});

const Physics = @import("../physics.zig");

const Players = @import("../players.zig");

const Palette = @import("../palette.zig");

pub const Default = struct {
    pub fn enter (state: *State) !Code {
        _ = try List.allocate(&state.Physics_Container);
        _ = try Players.create(state);
        var test_player = try Players.create(state);
        state.Physics_Container.Data[
            state.Player_Container.Data[test_player].data.Physics
        ].data.Position.x = 100;
        
        return Code.Continue;
    }
    pub fn leave (state: *State) !Code {
        _ = state;
        return Code.Continue;
    }
    pub fn update (state: *State) !Code {
        Players.update(state);
        Physics.update(state);
        return Code.Continue;
    }
    pub fn render (state: *State) !Code {
        // Firing up raylib
        raylib.BeginDrawing();
        defer {raylib.EndDrawing();}
        // Wipe the screen
        raylib.ClearBackground(Palette.white);
        // Draw the random squares
        var index: usize = 0;
        while ( index < state.Physics_Container.final_index ) {
            const entity = state.Physics_Container.Data[index];
            defer { index += 1; }
            if (!entity.in_use) { continue; }
            raylib.DrawTexture(
                state.texture,
                @intFromFloat(state.Physics_Container.Data[index].data.Position.x),
                @intFromFloat(state.Physics_Container.Data[index].data.Position.y),
                Palette.white
            );
        }
        // Finally draw the FPS
        raylib.DrawFPS(100, 100);
        // Success!
        return Code.Continue;
    }
};