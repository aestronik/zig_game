const List    = @import("list.zig");
const State   = @import("state.zig");
const raylib  = @cImport({@cInclude("raylib.h");});

const Sprite_Sheet = @import("display/sprite_sheet.zig");
const Sprite       = @import("display/sprite.zig");

const Physics      = @import("physics.zig");

const CONFIG = @import("../config.zig");

const std     = @import("std");
const print   = std.debug.print;


/// Associated type
pub const Entity = struct {
    Physics:        usize,
    Controls:       struct {
        Up:             u8,
        Down:           u8,
        Left:           u8,
        Right:          u8
    },
    size:           f32,
    health:         i32,
    Sprite:         usize,
    Target:         raylib.Vector2
};
/// Setting up the state properly
pub fn initialize (state: *State.Entity) void {
    _ = state;
    return;
}
/// Create a player and return its index!
pub fn create (state: *State.Entity) !usize {
    const player_index   = try List.allocate(&state.Player_Container);
    const player_physics = try Physics.create(state);

    var Players = &state.Player_Container.Data;
    // Physics
    var player = &Players[player_index].data;
    player.Physics = player_physics;
    // Controls
    player.Controls.Up    = 87;
    player.Controls.Down  = 83;
    player.Controls.Left  = 65;
    player.Controls.Right = 68;
    // Target
    player.Target.x = 0;
    player.Target.y = 0;
    // Dodging
    player.size     = 32;
    player.health   = 20;
    // Visuals
    player.Sprite = try Sprite.create(state);
    state.Sprite_Container.Data[
        player.Sprite
    ].data.Sheet = try Sprite_Sheet.create(
        state,
        raylib.LoadTexture("assets/visual/missing_texture_32.png"),
        raylib.Vector2 {.x = 32, .y = 32},
        [CONFIG.ANIMATION_SIZE]f32{ 1, 4, 0, 2, 0, 0, 0, 0 }
    );

    return player_index;
}
pub fn delete (state: *State.Entity, index: usize) !void  {
    const player = state.Player_Container.Data[index].data;
    // Deallocate the sprite and the physics
    _ = try Sprite.delete(state, player.Sprite);
    _ = try Physics.delete(state, player.Physics);
    _ = try List.deallocate(&state.Player_Container, index);
}
/// Setting up the logic, just Newtonian Physics!
pub fn update (state: *State.Entity) void {
    var index: usize = 0;

    while (index < state.Player_Container.final_index) {
        defer { index += 1; }

        if (!state.Player_Container.Data[index].in_use) { continue; }

        var player = &state.Player_Container.Data[index].data;
        var player_physics = &state.Physics_Container.Data[player.Physics].data;
        // Controls
        player_physics.*.Velocity.x = 0;
        player_physics.*.Velocity.y = 0;

        var moving = false;

        if (raylib.IsKeyDown(player.Controls.Up))    { player_physics.*.Position.y -= 1.0; moving = true; }
        if (raylib.IsKeyDown(player.Controls.Down))  { player_physics.*.Position.y += 1.0; moving = true; }
        if (raylib.IsKeyDown(player.Controls.Left))  { player_physics.*.Position.x -= 1.0; moving = true; }
        if (raylib.IsKeyDown(player.Controls.Right)) { player_physics.*.Position.x += 1.0; moving = true; }

        const sprite = &state.Sprite_Container.Data[player.Sprite].data;
        sprite.*.Position.x = player_physics.Position.x;
        sprite.*.Position.y = player_physics.Position.y;

        if (moving) { sprite.*.animation = 1; }
        else if (raylib.IsKeyDown(81)) { sprite.*.animation = 2; }
        else if (raylib.IsKeyDown(69)) { sprite.*.animation = 3; }
        else { sprite.*.animation = 0; }
    }
}