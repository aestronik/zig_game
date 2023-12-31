const std     = @import("std");
const print   = std.debug.print;

const Scene   = @import("main.zig");
const State   = Scene.State;
const Code    = Scene.Code;

const Sprites = @import("../display/sprite.zig");

const Vector  = @import("../vector.zig");

const List    = @import("../list.zig");

const raylib  = @cImport({@cInclude("raylib.h");});

const Physics = @import("../physics.zig");

const Players = @import("../players.zig");

const Camera = @import("../display/camera.zig");

const Palette = @import("../display/palette.zig");

const Projectile = @import("../projectile.zig");

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
        Camera.update(state);
        if (raylib.IsMouseButtonDown(0)) {
            const projectile_index = try Projectile.create(state);
            var   projectile = &state.Projectile_Container.Data[projectile_index].data;
            const camera = state.Camera;
            const mouse  = raylib.GetMousePosition();
            var projectile_physics = &state.Physics_Container.Data[projectile.Physics].data;
            projectile_physics.Position.x = Camera.interpret_x(camera, mouse.x);
            projectile_physics.Position.y = Camera.interpret_y(camera, mouse.y);
            projectile_physics.Velocity   = Vector.normalize(Vector.direction(projectile_physics.Position, raylib.Vector2 {.x = 0, .y = 0}));
        }
        Players.update(state);
        Physics.update(state);
        Sprites.update(state);
        Projectile.update(state);
        return Code.Continue;
    }
    pub fn render (state: *State) !Code {
        // Firing up raylib
        raylib.BeginDrawing();
        defer {raylib.EndDrawing();}
        // Wipe the screen
        raylib.ClearBackground(Palette.white);
        // Draw the random squares
        Sprites.render(state);
        const camera = state.Camera;
        const mouse  = raylib.GetMousePosition();
        // Finally draw the FPS
        raylib.DrawFPS(100, 100);

        const position = state.Physics_Container.Data[
                state.Player_Container.Data[0].data.Physics
            ].data.Position;

        raylib.DrawLineV(
            raylib.Vector2 {
                .x = Camera.offset_x( camera, Camera.interpret_x(camera, mouse.x) ),
                .y = Camera.offset_y( camera, Camera.interpret_y(camera, mouse.y) )
            },
            raylib.Vector2 {
                .x = Camera.offset_x( camera, position.x ),
                .y = Camera.offset_y( camera, position.y )
            },
            Palette.blue
        );
        // Success!
        return Code.Continue;
    }
};